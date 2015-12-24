requires 'perl', '5.006';
requires 'base';
requires 'lib';
requires 'strict';
requires 'warnings';
requires 'Carp';
requires 'Exporter';
requires 'Symbol';

requires 'PadWalker';
requires 'Devel::Caller';
requires 'Sentinel';

on test => sub {
	requires 'Test::More', '0.88';
};

# vim: ft=perl
