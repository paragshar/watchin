/**
 * All template navigation goes here
 */
WatchinNgApp.config(['$routeProvider', 'RestangularProvider', function($routeProvider, RestangularProvider) {
	  
	$routeProvider.when('/home', {
		templateUrl: 'templates/home.htm',
		controller: userListCtrl
	});	
	
	$routeProvider.when('/signup', {
		templateUrl: 'templates/signup.htm', 
		controller: signupCtrl
	});
	
	$routeProvider.when('/login', {
		templateUrl: 'templates/login.htm', 
		controller: loginCtrl
	});
  
  
    $routeProvider.otherwise({redirectTo: '/home'});
    
    RestangularProvider.setBaseUrl(url+"/api/");
    RestangularProvider.setRequestSuffix('.json');
    
}]);