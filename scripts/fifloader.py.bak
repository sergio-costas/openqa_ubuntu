#!/usr/bin/python3

import argparse
import json
import os
import subprocess
import sys

# you could refactor this just using a couple of dicts, but I don't
# think that would really make it *better*
# pylint:disable=too-many-locals, too-many-branches
def merge_inputs(inputs, clean=False):
    """Merge multiple input files. Expects JSON file names. Optionally
    validates the input files before merging, and the merged output.
    Returns a 5-tuple of machines, products, profiles, testsuites and
    jobtemplates (the first four as dicts, the fifth as a list).
    """
    machines = {}
    products = {}
    profiles = {}
    testsuites = {}
    jobtemplates = []

    for _input in inputs:
        try:
            with open(_input, 'r') as inputfh:
                data = json.load(inputfh)
        # we're just wrapping the exception a bit, so this is fine
        # pylint:disable=broad-except
        except Exception as err:
            print("Reading input file {} failed!".format(_input))
            sys.exit(str(err))

        # simple merges for all these
        for (datatype, tgt) in (
                ('Machines', machines),
                ('Products', products),
                ('Profiles', profiles),
                ('JobTemplates', jobtemplates),
        ):
            if datatype in data:
                if datatype == 'JobTemplates':
                    tgt.extend(data[datatype])
                else:
                    tgt.update(data[datatype])
        # special testsuite merging as described in the docstring
        if 'TestSuites' in data:
            for (name, newsuite) in data['TestSuites'].items():
                try:
                    existing = testsuites[name]
                    # combine and stash the profiles
                    existing['profiles'].update(newsuite['profiles'])
                    combinedprofiles = existing['profiles']
                    # now update the existing suite with the new one, this
                    # will overwrite the profiles
                    existing.update(newsuite)
                    # now restore the combined profiles
                    existing['profiles'] = combinedprofiles
                except KeyError:
                    testsuites[name] = newsuite

    return (machines, products, profiles, testsuites, jobtemplates)

def generate_job_templates(products, profiles, testsuites):
    """Given machines, products, profiles and testsuites (after
    merging, but still in intermediate format), generates job
    templates and returns them as a list.
    """
    jobtemplates = []
    for (name, suite) in testsuites.items():
        if 'profiles' not in suite:
            print("Warning: no profiles for test suite {}".format(name))
            continue
        for (profile, prio) in suite['profiles'].items():
            jobtemplate = {'test_suite_name': name, 'prio': prio}
            # x86_64 compose
            # jobtemplate['group_name'] = 'fedora'
            # This group name isn't ideal. Ideally the groups would be split up on kind of tests
            # e.g. installer tests or desktop applications tests or something.
            # jobtemplate['group_name'] = 'ubuntu'
            jobtemplate['machine_name'] = profiles[profile]['machine']
            product = products[profiles[profile]['product']]
            jobtemplate['arch'] = product['arch']
            jobtemplate['flavor'] = product['flavor']
            jobtemplate['distri'] = product['distri']
            jobtemplate['version'] = product['version']
            jobtemplate['group_name'] = product['name']
            # if block not needed by the looks. (for our version)
            if jobtemplate['machine_name'] == 'ppc64le':
                if 'updates' in product['flavor']:
                    jobtemplate['group_name'] = "Fedora PowerPC Updates"
                else:
                    jobtemplate['group_name'] = "Fedora PowerPC"
            elif jobtemplate['machine_name'] in ('aarch64', 'ARM'):
                if 'updates' in product['flavor']:
                    jobtemplate['group_name'] = "Fedora AArch64 Updates"
                else:
                    jobtemplate['group_name'] = "Fedora AArch64"
            elif 'updates' in product['flavor']:
                # x86_64 updates
                jobtemplate['group_name'] = "Fedora Updates"
            jobtemplates.append(jobtemplate)
    return jobtemplates


def reverse_qol(machines, products, testsuites):
    """Reverse all our quality-of-life improvements in Machines,
    Products and TestSuites. We don't do profiles as only this loader
    uses them, upstream loader does not. We don't do jobtemplates as
    we don't do any QOL stuff for that. Returns the same tuple it's
    passed.
    """
    # first, some nested convenience functions
    def to_list_of_dicts(datadict):
        # lol
        """Convert our nice dicts to upstream's stupid list-of-dicts-with
        -name-keys.
        """
        converted = []
        for (name, item) in datadict.items():
            item['name'] = name
            converted.append(item)
        return converted

    def dumb_settings(settdict):
        # lol
        """Convert our sensible settings dicts to upstream's weird-ass
        list-of-dicts format.
        """
        converted = []
        for (key, value) in settdict.items():
            converted.append({'key': key, 'value': value})
        return converted

    # drop profiles from test suites - these are only used for job
    # template generation and should not be in final output. if suite
    # *only* contained profiles, drop it
    for suite in testsuites.values():
        del suite['profiles']
    testsuites = {name: suite for (name, suite) in testsuites.items() if suite}

    machines = to_list_of_dicts(machines)
    products = to_list_of_dicts(products)
    testsuites = to_list_of_dicts(testsuites)
    for datatype in (machines, products, testsuites):
        for item in datatype:
            if 'settings' in item:
                item['settings'] = dumb_settings(item['settings'])

    return (machines, products, testsuites)


def parse_args(args):
    """Parse arguments with argparse."""
    parser = argparse.ArgumentParser(description=(
        "Alternative openQA template loader/generator, using a more "
        "convenient input format. See docstring for details. "))
    parser.add_argument(
        '-l', '--load', help="Load the generated templates into openQA.",
        action='store_true')
    parser.add_argument(
        '--loader', help="Loader to use with --load",
        default="/usr/share/openqa/script/load_templates")
    parser.add_argument(
        '-w', '--write', help="Write the generated templates in JSON "
        "format.", action='store_true')
    parser.add_argument(
        '--filename', help="Filename to write with --write",
        default="generated.json")
    parser.add_argument(
        '--host', help="If specified with --load, gives a host "
        "to load the templates to. Is passed unmodified to upstream "
        "loader.")
    parser.add_argument(
        '-c', '--clean', help="If specified with --load, passed to "
        "upstream loader and behaves as documented there.",
        action='store_true')
    parser.add_argument(
        '-u', '--update', help="If specified with --load, passed to "
        "upstream loader and behaves as documented there.",
        action='store_true')
    parser.add_argument(
        'files', help="Input JSON files", nargs='+')
    return parser.parse_args(args)

def run(args):
    """Read in arguments and run the appropriate steps."""
    args = parse_args(args)
    (machines, products, profiles, testsuites, jobtemplates) = merge_inputs(
        args.files, clean=args.clean)
    jobtemplates.extend(generate_job_templates(products, profiles, testsuites))
    (machines, products, testsuites) = reverse_qol(machines, products, testsuites)
    # now produce the output in upstream-compatible format
    out = {}
    if jobtemplates:
        out['JobTemplates'] = jobtemplates
    if machines:
        out['Machines'] = machines
    if products:
        out['Products'] = products
    if testsuites:
        out['TestSuites'] = testsuites
    if args.write:
        # write generated output to given filename
        with open(args.filename, 'w') as outfh:
            # for some reason, this replacement is needed.
            outfh.write(json.dumps(out, indent=4).replace(":", " =>"))
            # original
            # json.dump(out, outfh, indent=4)
    if args.load:
        # load generated output with given loader (defaults to
        # /usr/share/openqa/script/load_templates)
        loadargs = [args.loader]
        if args.host:
            loadargs.extend(['--host', args.host])
        if args.clean:
            loadargs.append('--clean')
        if args.update:
            loadargs.append('--update')
        loadargs.append('-')
        subprocess.run(loadargs, input=json.dumps(out), text=True, check=True)

def main():
    """Main loop."""
    try:
        run(args=sys.argv[1:])
    except KeyboardInterrupt:
        sys.stderr.write("Interrupted, exiting...\n")
        sys.exit(1)

if __name__ == '__main__':
    main()

# vim: set textwidth=100 ts=8 et sw=4:
