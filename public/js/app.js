'use strict';
var url = 'http://localhost/watchin/public/request.php';
var WatchinNgApp = angular.module('watchinApp', ['restangular', 'ngCookies']);

WatchinNgApp.run(['$rootScope', 'UserApi', '$location', '$cookieStore', function(root, UserApi, $location, $cookieStore) {
	root.$on('$routeChangeSuccess', function(scope, currView, prevView) { 
		root.url = url;
		root.loggedIn = $cookieStore.get('loggedin');
		root.userName = $cookieStore.get('user_name');
		if (root.loggedIn == "true") {
			root.loggedOut = "";
			UserApi.isLogged = true;
		}
		else {
			root.loggedOut = "true";
			UserApi.isLogged = false;
		}
		
		if(currView){
			if (!currView.access.isFree && !UserApi.isLogged) {
				$location.path('/login');
			}
		}
	});
}]);