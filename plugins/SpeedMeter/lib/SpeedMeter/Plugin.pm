package SpeedMeter::Plugin;

use strict;
use Time::HiRes;

sub _hdlr_speedmeter {
    my ( $ctx, $args, $cond ) = @_;
    my $name = $args->{ name };
    my $start = Time::HiRes::time();
    my $value = $ctx->stash( 'builder' )->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    my $end = Time::HiRes::time();
    my $time = $end - $start;
    my $message = MT->translate( 'The files for [_1] have been published.', "'$name'" );
    $message .= MT->translate( 'Publish time: [_1].', $time );
    MT->log( $message );
    return $value;
}

1;