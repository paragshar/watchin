/**
 * user registration
 * @param $scope
 * @param $location
 * @param UserApi
 */
function signupCtrl ($scope, $location, UserApi) {
	$scope.create = function () {
		UserApi.users.post($scope.User).then(function(){
			$location.path('/home');
		});
	}
}

function loginCtrl ($scope, $location, UserApi, $cookieStore) {
	$scope.login = function () {
		UserApi.user_login.post($scope.User).then(function (response){
			if(response.user){
				UserApi.username = response.user.name;
				$cookieStore.put('auth_token', response.auth_token);
				$cookieStore.put('user_id', response.user.id);
				$cookieStore.put('loggedin', 'true');
				$location.path('/home');
			}else{
				UserApi.username = '';
				$location.path('/login');
			}
		});
	}
}

function logoutCtrl (UserApi, $location, $cookieStore) {
	var user_logout = {auth_token: $cookieStore.get('auth_token')};
	UserApi.user_logout.remove(user_logout).then(function() {
		UserApi.username = '';
		$cookieStore.put('auth_token', '');
		$cookieStore.put('loggedin', '');
		$cookieStore.put('user_id', '');
		$location.path('/login');
	});
}

function homeCtrl ($scope, UserApi, FriendApi, $cookieStore, $location) {
	$scope.users = UserApi.users.getList();
	
	$scope.addFriend = function (user_id) {
		FriendApi.friend_request.customPOST("", {'auth_token': $cookieStore.get('auth_token')}, "",{'friend_id': user_id}).then(function (response) {
			console.log(response);
		});
	}
}

function userProfileCtrl ($scope, UserApi, $cookieStore, $location, Restangular) {
	$scope.userData = UserApi.user.one($cookieStore.get('user_id')).get();
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
		UserApi.users.customPUT("",auth_token, "", $scope.User).then(function (response){
			$scope.userData = response;
		});
		$scope.user_update = "";
		$scope.user_detail = "true";
	}
	
	
}
