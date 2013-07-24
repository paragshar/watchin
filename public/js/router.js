/**
 * All template navigation done here
 */
WatchinNgApp.config(['$routeProvider', 'RestangularProvider', function($routeProvider, RestangularProvider) {
	  
	$routeProvider.when('/home', {
		templateUrl: 'templates/home.htm',
		controller: homeCtrl,
		access: { isFree: false	}
	});	
	
	$routeProvider.when('/signup', {
		templateUrl: 'templates/signup.htm', 
		controller: signupCtrl,
		access: { isFree: true }
	});
	
	$routeProvider.when('/login', {
		templateUrl: 'templates/login.htm', 
		controller: loginCtrl,
		access: { isFree: true }
	});
	
	$routeProvider.when('/user_profile', {
		templateUrl: 'templates/user_profile.htm', 
		controller: userProfileCtrl,
		access: { isFree: false }
	});
	
	$routeProvider.when('/my_friends', {
		templateUrl: 'templates/my_friends.htm', 
		controller: friendsListCtrl,
		access: { isFree: false }
	});
	
	$routeProvider.when('/approve_requests', {
		templateUrl: 'templates/approve_request.htm', 
		controller: FriendshipRequestListCtrl,
		access: { isFree: false }
	});
	
	$routeProvider.when('/logout', {
		templateUrl: 'templates/home.htm',
		controller: logoutCtrl,
		access: { isFree: false	}
	});
  
  
    $routeProvider.otherwise({redirectTo: '/home'});
    
    RestangularProvider.setBaseUrl(url+"/api/");
    RestangularProvider.setRequestSuffix('.json');
    
}]);