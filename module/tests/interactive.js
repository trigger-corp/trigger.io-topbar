/* global forge, asyncTest, module, ok, start, askQuestion, runOnce, equal */

module("forge.topbar");

if (forge.is.ios()) {

    asyncTest("Disable status bar translucency, iOS", 1, function() {
        forge.topbar.setTranslucent(false, function () {
            askQuestion("Status bar/topbar should no longer be translucent", {
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

    asyncTest("Enable status bar translucency, iOS", 1, function() {
        forge.topbar.setTranslucent(true, function () {
            askQuestion("Status bar/topbar should be translucent", {
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

    asyncTest("Set status bar style, iOS", 1, function() {
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

    asyncTest("Set status bar style, iOS", 1, function() {
        forge.topbar.setTint([255, 255, 255, 255]);
        forge.topbar.setStatusBarStyle('default', function () {
            askQuestion("Status bar/topbar should be white with black text", {
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


asyncTest("Initial state", 1, function() {
    forge.topbar.setTranslucent(true);
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
        askQuestion("Press the star shaped button (with no number on Android and iOS)", {
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

asyncTest("Image Title Centering - left", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/1.png",
            prerendered: true,
            position: "left"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - left small", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage-small.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/1.png",
            prerendered: true,
            position: "left"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - wide", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage-wide.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/1.png",
            prerendered: true,
            position: "left"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - tall", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage-tall.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/1.png",
            prerendered: true,
            position: "left"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - right", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/2.png",
            prerendered: true,
            position: "right"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - right small", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage-small.png");
        forge.topbar.addButton({
            icon: "fixtures/topbar/2.png",
            prerendered: true,
            position: "right"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - both", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage.png");
        forge.topbar.addButton({
            text: "left",
            position: "left"
        });
        forge.topbar.addButton({
            icon: "fixtures/topbar/2.png",
            prerendered: true,
            position: "right"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Image Title Centering - both small", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitleImage("fixtures/topbar/titleimage-small.png");
        forge.topbar.addButton({
            text: "left",
            position: "left"
        });
        forge.topbar.addButton({
            icon: "fixtures/topbar/2.png",
            prerendered: true,
            position: "right"
        });
        askQuestion("Is the topbar title image centered?", {
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
});

asyncTest("Title Text Centering - left", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitle("TopBar Module");
        forge.topbar.addButton({
            icon: "fixtures/topbar/1.png",
            prerendered: true,
            position: "left"
        });
        askQuestion("Is the topbar title text centered?", {
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
});

asyncTest("Title Text Centering - right", 1, function() {
    forge.topbar.removeButtons(function () {
        forge.topbar.setTitle("TopBar Module");
        forge.topbar.addButton({
            icon: "fixtures/topbar/2.png",
            prerendered: true,
            position: "right"
        });
        askQuestion("Is the topbar title text centered?", {
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
});
