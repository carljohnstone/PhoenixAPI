package PhoenixAPI::Controller::Article;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config(default => 'application/json');

use PhoenixAPI::Presenter::Article;
use PhoenixAPI::Validator::ArticleList;

=head1 NAME

PhoenixAPI::Controller::Article - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub article_list : Path('/article') :Args(0) : ActionClass('REST') { }

sub article_list_GET {
    my ( $self, $c ) = @_;
    my $validator = PhoenixAPI::Validator::ArticleList->new({
        'c' => $c,
    });

    my @articles = $c->model('DB::Article')->published->search({},{
        rows => $validator->rows,
        page => $validator->page,
        order_by => $validator->order,
    })->all;

    $self->status_ok(
        $c,
        entity => {
            'page' => $validator->page,
            'rows' => $validator->rows,
            'results' => scalar(@articles),
            'articles' => [
                map
                {
                    PhoenixAPI::Presenter::Article->new({
            'c' => $c,
            'article' => $_,
        })->json
                }
                @articles,
            ],
        },
    );
}

sub single_article : Path('/article') : Args(1) : ActionClass('REST') {
    my ( $self, $c, $article_id ) = @_;

    $c->stash->{'article'} = $c->model('DB::Article')->find($article_id);
}

sub single_article_GET {
    my ( $self, $c, $article_id ) = @_;

    my $article = $c->stash->{'article'};
    if ( defined($article) && $article->published ) {
        my $article_presenter = PhoenixAPI::Presenter::Article->new({
            'c' => $c,
            'article' => $article,
        });

        $self->status_ok(
            $c,
            entity => $article_presenter->json,
        );
    }
    else {
        $self->status_not_found( $c,
            message => "Could not find Article $article_id" );
    }
}

=encoding utf8

=head1 AUTHOR

Carl Johnstone

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
