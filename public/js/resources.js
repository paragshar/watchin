WatchinNgApp.factory("DataService", function (Restangular) {
	var users = Restangular.all('users');
	var user_login = Restangular.all('users/sign_in');
    return {
        users: users,
        user_login: user_login
    };
});