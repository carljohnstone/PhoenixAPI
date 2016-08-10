package PhoenixAPI::Validator::ArticleList;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

subtype 'PositiveInt',
     as 'Int',
     where { $_ > 0 },
     message { "$_ is not a positive integer!" };

has 'c' => (
    is => 'ro',
    isa => 'PhoenixAPI',
    required => 1,
);

has 'page' => (
    is => 'ro',
    isa => 'PositiveInt',
    required => 1,
    lazy_build => 1,
);

sub _build_page {
    return shift->c->req->param('page') || 1;
}

has 'rows' => (
    is => 'ro',
    isa => 'PositiveInt',
    required => 1,
    lazy_build => 1,
);

sub _build_rows {
    return shift->c->req->param('rows') + 0 || 10;
}

has 'order' => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
    lazy_build => 1,
);

sub _build_order {
    return {'-desc' => 'publication_date'};
}

__PACKAGE__->meta->make_immutable;
1;