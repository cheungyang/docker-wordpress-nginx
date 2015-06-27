<?php
/**
 * @package Site_Url
 * @version 1.0
 */
/*
Plugin Name: Site Url
Plugin URI: http://blog.alvacheung.com
Description: An implementation from https://wordpress.org/support/topic/dynamic-wordpress-base-url-for-hostname to override siteurl so that the siteurl in wp_options can be ignored.
Author: Alva Cheung
Version: 1.0
Author URI: http://blog.alvacheung.com
*/
function ml_clean_siteurl($url) {
        $url="http://".$_SERVER['HTTP_HOST'];
        return $url;
}
add_filter('option_siteurl', 'ml_clean_siteurl');
add_filter('option_home', 'ml_clean_siteurl');
?>