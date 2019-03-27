package SpeedMeter::Plugin;

use strict;
use Time::HiRes;

sub _hdlr_speedmeter {
    my ( $ctx, $args, $cond ) = @_;
    my $plugin = MT->component( 'SpeedMeter' );
    my $scope = lc( MT->config( 'SpeedMeterDebugScope' ) );
    if ( (! $scope ) || ( $scope && $scope eq 'none' ) ) {
        return $ctx->stash( 'builder' )->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    }
    my $tmpl = $ctx->stash( 'template' );
    my $name = $args->{ name } ? $args->{ name } : $tmpl->name;
    my $start = Time::HiRes::time();
    my $value = $ctx->stash( 'builder' )->build( $ctx, $ctx->stash( 'tokens' ), $cond );
    my $end = Time::HiRes::time();
    my $time = $end - $start;
    my $message = $plugin->translate( 'The template for [_1] have been build.', "'$name'" );
    $message .= $plugin->translate( 'Publish time: [_1].', $time );
    if ( $scope eq 'log' ) {
        my $app = MT->instance();
        $app->log( {
            message => $message,
            level => MT::Log::DEBUG(),
            category => $plugin->id,
        } );
    } elsif ( $scope eq 'screen' ) {
        my $prefix = $args->{ prefix } || '';
        my $suffix = $args->{ suffix } || '';
        $value .= $prefix . $message . $suffix;
    }
    return $value;
}

1;