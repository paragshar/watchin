WatchinNgApp.factory("DataService", function (Restangular) {
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