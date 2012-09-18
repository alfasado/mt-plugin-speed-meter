<?php
class SpeedMeter extends MTPlugin {
    var $app;
    var $registry = array(
        'name' => 'SpeedMeter',
        'id'   => 'SpeedMeter',
        'key'  => 'speedmeter',
        'tags' => array(
            'block' => array( 'speedmeter' => '_hdlr_speedmeter' ),
        ),
    );

    function _hdlr_speedmeter ( $args, $content, &$ctx, &$repeat ) {
        $localvars = array( 'speedmeter_id' );
        if (! isset( $content ) ) {
            $ctx->localize( $localvars );
            $key = md5( uniqid( rand(), 1 ) . $name );
            $ctx->stash( 'speedmeter_id', $key );
            $ctx->stash( $key, microtime( TRUE ) );
        } else {
            $app = $ctx->stash( 'bootstrapper' );
            $name = $args[ 'name' ];
            $repeat = FALSE;
            $key = $ctx->stash( 'speedmeter_id' );
            $start = $ctx->stash( $key );
            $end = microtime( TRUE );
            $ctx->restore( $localvars );
            $time = $end - $start;
            $message = $app->translate( 'The files for [_1] have been published.', "'{$name}'" );
            $message .= $app->translate( 'Publish time: [_1].', $time );
            $app->log( $message );
            return $content;
        }
    }
}

?>