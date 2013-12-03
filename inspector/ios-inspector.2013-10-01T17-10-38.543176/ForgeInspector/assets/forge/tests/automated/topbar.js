module("forge.topbar");

if (forge.is.mobile()) {
	asyncTest("hide", 1, function() {
		forge.topbar.hide(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("show", 1, function() {
		forge.topbar.show(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("setTitle", 1, function() {
		forge.topbar.setTitle("†és†", function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("setTitle - fail", 1, function() {
		forge.topbar.setTitle(undefined, function () {
			ok(false);
			start();
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("setTitleImage - '1.png'", 1, function() {
		forge.topbar.setTitleImage("fixtures/topbar/1.png", function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("setTitleImage - '/1.png'", 1, function() {
		forge.topbar.setTitleImage("/fixtures/topbar/1.png", function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("setTitleImage - fail", 1, function() {
		forge.topbar.setTitleImage(undefined, function () {
			ok(false);
			start();
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("setTint", 1, function() {
		forge.topbar.setTint([100, 50, 25, 255], function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("setTint - 'red'", 1, function() {
		forge.topbar.setTint("red", function () {
			ok(false);
			start();
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("setTint - fail", 1, function() {
		forge.topbar.setTint([], function () {
			ok(false);
			start();
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("removeButtons - no buttons", 1, function() {
		forge.topbar.removeButtons(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("addButton - text", 1, function() {
		forge.topbar.addButton({
			text: "†és†"
		}, function () {
		}, function () {
			ok(false);
			start();
		});
		ok(true);
		start();
	});

	asyncTest("addButton - icon '1.png'", 1, function() {
		forge.topbar.addButton({
			icon: "fixtures/topbar/1.png"
		}, function () {
		}, function () {
			ok(false);
			start();
		});
		ok(true);
		start();
	});

	asyncTest("addButton - too many", 1, function() {
		forge.topbar.addButton({
			text: "†és†"
		}, function () {
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("removeButtons", 1, function() {
		forge.topbar.removeButtons(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("addButton - icon '/1.png'", 1, function() {
		forge.topbar.addButton({
			icon: "/fixtures/topbar/1.png"
		}, function () {
		}, function () {
			ok(false);
			start();
		});
		ok(true);
		start();
	});

	asyncTest("addButton - icon and text", 1, function() {
		forge.topbar.addButton({
			icon: "fixtures/topbar/1.png",
			text: "†és†"
		}, function () {
		}, function () {
			ok(false);
			start();
		});
		ok(true);
		start();
	});

	asyncTest("removeButtons", 1, function() {
		forge.topbar.removeButtons(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("addButton - text, style, type, position", 1, function() {
		forge.topbar.addButton({
			text: "†és†",
			style: "done",
			type: "back",
			position: "left"
		}, function () {
		}, function () {
			ok(false);
			start();
		});
		ok(true);
		start();
	});

	asyncTest("addButton - position taken", 1, function() {
		forge.topbar.addButton({
			text: "†és†",
			position: "left"
		}, function () {
		}, function () {
			ok(true);
			start();
		});
	});

	asyncTest("removeButtons", 1, function() {
		forge.topbar.removeButtons(function () {
			ok(true);
			start();
		}, function () {
			ok(false);
			start();
		});
	});

	asyncTest("addButton - tint fail", 1, function() {
		forge.topbar.addButton({
			text: "†és†",
			tint: "red"
		}, function () {
		}, function () {
			ok(true);
			start();
		});
	});
}
