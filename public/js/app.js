'use strict';
var url = 'http://localhost/watchin/public/request.php';

var WatchinNgApp = angular.module('watchinApp', ['restangular', 'ngCookies']);

WatchinNgApp.run(['$rootScope', 'DataService', '$location', '$cookieStore', function(root, DataService, $location, $cookieStore) {
	root.$on('$routeChangeSuccess', function(scope, currView, prevView) { 
		
		root.loggedIn = $cookieStore.get('loggedin');
		if (root.loggedIn == "true") {
			root.loggedOut = "";
			DataService.isLogged = true;
		}
		else {
			root.loggedOut = "true";
			DataService.isLogged = false;
		}
		
		if(currView){
			if (!currView.access.isFree && !DataService.isLogged) {
				$location.path('/login');
			}
		}
	});
}]);