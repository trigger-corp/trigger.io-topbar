/* global forge, asyncTest, module, ok, start, askQuestion, runOnce, equal */

module("forge.topbar");

if (forge.is.mobile()) {
	asyncTest("Initial state", 1, function() {
		askQuestion("Is a top bar visible with the app name as the title and no buttons?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Title", 1, function() {
		forge.topbar.setTitle("héllø, world!");
		askQuestion("Is the title now 'héllø, World!'?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Hide", 1, function() {
		forge.topbar.hide();
		askQuestion("Is the topbar now hidden?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Show", 1, function() {
		forge.topbar.show();
		askQuestion("Is the topbar now visible again?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Add a button", 1, function() {
		forge.topbar.addButton({icon: "fixtures/topbar/1.png", prerendered: true}, runOnce(function () {
			ok(true, "Success");
			start();
		}));
		askQuestion("Press the button with a red image displaying the number 1", {
			"Nothing happened": function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Add a button", 1, function() {
		forge.topbar.removeButtons(function () {
			forge.topbar.addButton({icon: "fixtures/topbar/2.png"}, runOnce(function () {
				ok(true, "Success");
				start();
			}));
			askQuestion("Press the star shaped button (with no number on Android and iOS 7)", {
				"Nothing happened": function () {
					ok(false, "User claims failure");
					start();
				}
			});
		});
	});
	asyncTest("Add a 2nd button", 1, function() {
		forge.topbar.addButton({text: "€2"}, runOnce(function () {
			ok(true, "Success");
			start();
		}));
		askQuestion("Press the button labelled €2", {
			"Nothing happened": function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Remove button", 1, function() {
		forge.topbar.removeButtons();
		askQuestion("Are the buttons gone?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Add a button - done", 1, function() {
		forge.topbar.addButton({text: "ØK", style: "done"}, runOnce(function () {
			ok(true, "Success");
			forge.topbar.removeButtons();
			start();
		}));
		askQuestion("Press the button if it shows 'ØK' and is styled differently to previous buttons (probably with a blue background)", {
			"Nothing happens or the button is not as described": function () {
				ok(false, "User claims failure");
				forge.topbar.removeButtons();
				start();
			}
		});
	});
	asyncTest("Title - Image", 1, function() {
		forge.topbar.setTitleImage("fixtures/topbar/3.png");
		askQuestion("Is the title an image with the number 3?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Title - back to text", 1, function() {
		forge.topbar.setTitle("†î†lé");
		askQuestion("Is the title now 'Title'?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Tint", 1, function() {
		forge.topbar.setTint([150,255,150,255]);
		askQuestion("Is the bar now green?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("TitleTint", 1, function() {
		forge.topbar.setTitleTint([255,0,0,255]);
		askQuestion("Is the bar now green with red text?", {
			Yes: function () {
				ok(true, "Success");
				start();
			},
			No: function () {
				ok(false, "User claims failure");
				start();
			}
		});
	});
	asyncTest("Add a button - tint", 1, function() {
		forge.topbar.addButton({text: "®é∂", tint: [255,0,0,255]}, runOnce(function () {
			ok(true, "Success");
			forge.topbar.removeButtons();
			start();
		}));
		askQuestion("Press the button if it shows '®é∂' and is red", {
			"Nothing happens or the button is not as described": function () {
				ok(false, "User claims failure");
				forge.topbar.removeButtons();
				start();
			}
		});
	});
	asyncTest("Add a button - back", 1, function() {
		window.location.hash = "foo";
		window.location.hash = "bar";
		forge.topbar.addButton({text: "Back", type: "back", position: "left", style:"back"});
		askQuestion("Press the button if it shows 'Back'", {
			"Button pressed": function () {
				equal(window.location.hash, "#foo", "Did go back");
				start();
			},
			"Something is wrong": function () {
				ok(false, "User claims failure");
				forge.topbar.removeButtons();
				start();
			}
		});
	});
	asyncTest("Set status bar style, iOS 7", 1, function() {
		forge.topbar.setTint([0, 0, 0, 255]);
		forge.topbar.setStatusBarStyle('light_content', function () {
			askQuestion("Status bar/topbar should be black with white text", {
				Yes: function () {
					ok(true, "User claims success");
					start();
				},
				No: function () {
					ok(false, "User claims failure");
					start();
				}
			});
		}, function () {
			ok(true, "Not available");
			start();
		});
	});
}
