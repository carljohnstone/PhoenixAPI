package PhoenixAPI::Presenter::Article;
use Moose;
use namespace::autoclean;

has 'c' => (
    is => 'ro',
    isa => 'PhoenixAPI',
    required => 1,
);

has 'article' => (
    is => 'ro',
    isa => 'PhoenixAPI::Model::DB::Article',
    required => 1,
);

has 'json' => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
    lazy_build => 1,
);

sub _build_json {
    my $self = shift;
    return {
        id => $self->article->id,
        section => $self->article->section,
        headline => $self->article->headline,
        teaser => $self->article->teaser  ,
        bodytext => $self->article->bodytext,
        publication_date => $self->article->publication_date->iso8601,
        show_on_homepage => $self->article->show_on_homepage,
    };

}
__PACKAGE__->meta->make_immutable;
1;