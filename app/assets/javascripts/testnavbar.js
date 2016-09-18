(function($) {
  console.log("load test")
    var $window = $(window),
        $nav = $('#header');

    function resize() {
        if ($window.width() < 514) {
          console.log("detect width")
            return $nav.addClass(' navbar-default');
        }

        $nav.removeClass('navbar-default');
    }

    $window
        .resize(resize)
        .trigger('resize');
})(jQuery);
