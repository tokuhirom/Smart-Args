use inc::Module::Install;
name 'Smart-Args';
all_from 'lib/Smart/Args.pm';

requires 'PadWalker'    => 1.92;
requires 'Mouse'        => 0.92;
requires 'Scalar::Util' => 1.21;    # old version has bug.
requires 'Exporter'     => 5.63;

tests('t/*.t t/*/*.t t/*/*/*.t');
author_tests 'xt';

if ($Module::Install::AUTHOR) {
	test_requires 'MouseX::Types';
	test_requires 'MooseX::Types';
}

auto_set_repository;
test_requires 'Test::Requires';
test_requires 'Test::More' => 0.96;
WriteAll;
