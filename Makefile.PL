use inc::Module::Install;
name 'Smart-Args';
all_from 'lib/Smart/Args.pm';

requires 'PadWalker'    => 1.9;
requires 'Mouse'        => 0.82;
requires 'Scalar::Util' => 1.21;    # old version has bug.

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests 'xt';

auto_set_repository;
test_requires 'Test::Requires';
test_requires 'Test::More' => 0.88;
auto_include;
WriteAll;
