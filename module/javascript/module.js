/* global forge */
forge['topbar'] = {
	'show': function ( success, error) {
		forge.internal.call("topbar.show", {}, success, error);
	},
	'hide': function (success, error) {
		forge.internal.call("topbar.hide", {}, success, error);
	},
	'setTitle': function (title, success, error) {
		forge.internal.call("topbar.setTitle", {title: title}, success, error);
	},
	'setTitleImage': function (icon, success, error) {
		if (icon && icon[0] === "/") {
			icon = icon.substr(1);
		}
		forge.internal.call("topbar.setTitleImage", {icon: icon}, success, error);
	},
	'setTint': function (color, success, error) {
		forge.internal.call("topbar.setTint", {color: color}, success, error);
	},
	'setTitleTint': function (color, success, error) {
		forge.internal.call("topbar.setTitleTint", {color: color}, success, error);
	},
	'addButton': function (params, callback, error) {
		if (params.icon && params.icon[0] === "/") {
			params.icon = params.icon.substr(1);
		}
		forge.internal.call("topbar.addButton", params, function (callId) {
			callback && forge.internal.addEventListener('topbar.buttonPressed.'+callId, callback);
		}, error);
	},
	'removeButtons': function (success, error) {
		forge.internal.call("topbar.removeButtons", {}, success, error);
	},
	'setStatusBarStyle': function (style, success, error) {
		forge.internal.call("topbar.setStatusBarStyle", {style: style}, success, error);
	}
};
