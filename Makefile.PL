use inc::Module::Install;
name 'args';
all_from 'lib/args.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
