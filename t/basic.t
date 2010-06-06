use Test::More tests => 20;

my ($foodestr, $bardestr);

package Foo;

BEGIN { Test::More::use_ok('Class::Closure') }

sub CLASS {
	destroy { $foodestr++ };

	my $a = 1;              # Private
	has(my $b) = 2;         # Read Only
	public(my $c) = 3;      # Er, yep, public
	accessor d => (         # Magic accessor.
		set => sub { $b = $_[1] },
		get => sub { $c },
	);
	method e => sub { 2*$_[1] };
	method f => sub { 2*$_[0]->g };
};

package Baz;

sub new {
	bless { x => 42 } => ref $_[0] || $_[0];
}

sub g : lvalue {
	$_[0]->{x};
}

package Bar;

BEGIN { Test::More::use_ok('Class::Closure') }

sub CLASS {
	destroy { $bardestr++ };

	extends 'Foo';
	extends 'Baz';

	has my $b;

	method BUILD => sub { $b = 13; };
	method FALLBACK => sub { 69 };
}

package main;

my $foo = Foo->new;
my $bar = Bar->new;

ok(!eval { $foo->a },           "Private");
is($foo->b, 2,                  "Read Only");
ok(!eval { $foo->b = 50 },      "Read Only");
is($foo->c, 3,                  "Public");
is($foo->c = 4, 4,              "Public");
is($foo->c, 4,                  "Public");
is($foo->d, $foo->c,            "Accessor");
is($foo->d = 10, $foo->c,       "Accessor");
is($foo->b, 10,                 "Accessor");
is($foo->e(21), 42,             "Method");
is($bar->f, 84,                 "Extends/Represents");
is($bar->b, 13,                 "Build/Extends");
is($bar->c, 3,                  "Extends");
is($bar->nada, 69,              "Autoload");
undef $bar;
is($bardestr, 1,                "Destroy");
is($foodestr, 1,                "Destroy");
undef $foo;
is($bardestr, 1,                "Destroy");
is($foodestr, 2,                "Destroy");
