WatchinNgApp.factory("UserApi", function (Restangular) {
	var users = Restangular.all('users');
	var user = Restangular.one('users');
	var user_login = Restangular.all('users/sign_in');
	var user_logout = Restangular.one('users/sign_out');
	
	var user_auth = {
			isLogged: false,
			username: ''
		};
	
    return {
    	user_auth: user_auth,
        users: users,
        user: user,
        user_login: user_login,
        user_logout: user_logout
    };
});

WatchinNgApp.factory("FriendApi", function (Restangular) {
	var friends = Restangular.all('friendships');
	var friend = Restangular.one('friendships');
	var friend_request = Restangular.one('friendship_requests');
	
    return {
    	friends: friends,
        friend: friend,
        friend_request: friend_request
    };
});