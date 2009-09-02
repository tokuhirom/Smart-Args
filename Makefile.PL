use inc::Module::Install;
name 'args';
all_from 'lib/args.pm';

requires 'PadWalker'    => 1.9;
requires 'Any::Moose'   => 0.10;
requires 'Scalar::Util' => 1.21;    # old version has bug.

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests 'xt';

auto_set_repository;
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
