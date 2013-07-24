/**
 * user registration
 * @param $scope
 * @param $location
 * @param DataService
 */
function signupCtrl ($scope, $location, DataService) {
	$scope.create = function () {
		DataService.users.post($scope.User).then(function(){
			$location.path('/home');
		});
	}
}

function loginCtrl ($scope, $location, DataService, $cookieStore) {
	$scope.login = function () {
		DataService.user_login.post($scope.User).then(function (response){
			if(response.user){
				DataService.username = response.user.name;
				$cookieStore.put('auth_token', response.auth_token);
				$cookieStore.put('user_id', response.user.id);
				$cookieStore.put('loggedin', 'true');
				$location.path('/home');
			}else{
				DataService.username = '';
				$location.path('/login');
			}
		});
	}
}

function logoutCtrl (DataService, $location, $cookieStore) {
	var user_logout = {auth_token: $cookieStore.get('auth_token')};
	DataService.user_logout.remove(user_logout).then(function() {
		DataService.username = '';
		$cookieStore.put('auth_token', '');
		$cookieStore.put('loggedin', '');
		$cookieStore.put('user_id', '');
		$location.path('/login');
	});
}

function userListCtrl ($scope, DataService) {
	$scope.user_name =  DataService.username;
	$scope.users = DataService.users.getList();
}

function userProfileCtrl ($scope, DataService, $cookieStore, $location, Restangular) {
	$scope.userData = DataService.user.one($cookieStore.get('user_id')).get();
	$scope.user_detail = "true";
	
	$scope.user_profile = function () {
		console.log('sffss');
		$scope.user_detail = "";
		$scope.user_update = "true";
	}
	$scope.userUpdate = function () {
		console.log($scope.User);
		console.log($cookieStore.get('auth_token'));
		var auth_token = {'auth_token': $cookieStore.get('auth_token')};
		DataService.users.customPUT("",auth_token, "", $scope.User).then(function (response){
			$scope.userData = response;
		});
		$scope.user_update = "";
		$scope.user_detail = "true";
	}
	
	
}
