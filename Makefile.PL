use inc::Module::Install;
name 'args';
all_from 'lib/args.pm';

requires 'PadWalker';
requires 'Mouse'; # will be remove deps?
requires 'Carp::Assert';

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests 'xt';

auto_set_repository;
build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
