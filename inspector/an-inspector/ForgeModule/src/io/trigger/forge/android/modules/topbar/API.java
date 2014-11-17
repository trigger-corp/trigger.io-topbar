package io.trigger.forge.android.modules.topbar;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeFile;
import io.trigger.forge.android.core.ForgeTask;
import io.trigger.forge.android.util.BitmapUtil;

import java.io.IOException;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.JsonArray;

public class API {
	public static void show(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				Util.topbar.setVisibility(View.VISIBLE);
				task.success();
			}
		});
	}

	public static void hide(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				Util.topbar.setVisibility(View.GONE);
				task.success();
			}
		});
	}

	public static void setTitle(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				Util.setTitle(ForgeApp.getActivity(), task.params.get("title").getAsString());
				task.success();
			}
		});
	}

	public static void setTitleImage(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				try {
					Util.setTitleImage(ForgeApp.getActivity(), task.params.get("icon"));
					task.success();
				} catch (IOException e) {
					task.error(e);
				}
			}
		});
	}

	public static void setTint(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				JsonArray colorArray = task.params.getAsJsonArray("color");
				int color = Color.argb(colorArray.get(3).getAsInt(), colorArray.get(0).getAsInt(), colorArray.get(1).getAsInt(), colorArray.get(2).getAsInt());
				ColorDrawable bgColor = new ColorDrawable(color);
				Util.topbar.setBackgroundDrawable(bgColor);
				task.success();
			}
		});
	}

	public static void setTitleTint(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				JsonArray colorArray = task.params.getAsJsonArray("color");
				int color = Color.argb(colorArray.get(3).getAsInt(), colorArray.get(0).getAsInt(), colorArray.get(1).getAsInt(), colorArray.get(2).getAsInt());
				ColorDrawable bgColor = new ColorDrawable(color);
				if (Util.titleText != null) {
					Util.titleText.setTextColor(color);
				}
				task.success();
			}
		});
	}
	
	public static void addButton(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				try {
					DisplayMetrics metrics = new DisplayMetrics();
					((Activity) ForgeApp.getActivity()).getWindowManager().getDefaultDisplay().getMetrics(metrics);
					final int margin = Math.round(metrics.density * 4);
					
					int tint = 0xFF1C8DD9;
					if (task.params.has("tint")) {
						JsonArray colorArray = task.params.getAsJsonArray("tint");
						tint = Color.argb(colorArray.get(3).getAsInt(), colorArray.get(0).getAsInt(), colorArray.get(1).getAsInt(), colorArray.get(2).getAsInt());
					}

					final LinearLayout button = new LinearLayout(ForgeApp.getActivity());
					button.setLongClickable(true);
					button.setOnTouchListener(new OnTouchListener() {
						public boolean onTouch(View v, MotionEvent event) {
							if (event.getAction() == android.view.MotionEvent.ACTION_DOWN) {
								// Highlight
								v.setAlpha(0.3f);
							} else if (event.getAction() == android.view.MotionEvent.ACTION_UP) {
								// Unhighlight
								v.setAlpha(1);
								
								// Send event
								if (task.params.has("type") && task.params.get("type").getAsString().toLowerCase().equals("back")) {
									// TODO: Add a method to ForgeActivity to do this.
									if (ForgeApp.getActivity().webView.canGoBack()) {
										ForgeApp.getActivity().webView.goBack();
									}
								} else {
									ForgeApp.event("topbar.buttonPressed." + task.callid);
								}
							}
							return false;
						}
					});

					button.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, 48));
					button.setGravity(Gravity.CENTER);

					if (task.params.has("text")) {
						TextView text = new TextView(ForgeApp.getActivity());
						text.setText(task.params.get("text").getAsString());
						text.setTextColor(tint);
						text.setTextSize(TypedValue.COMPLEX_UNIT_PX, metrics.density * 18);
						text.setGravity(Gravity.CENTER);
						text.setPadding(margin * 2, margin, margin * 2, margin);
						button.addView(text);
					} else if (task.params.has("icon")) {
						ImageView image = new ImageView(ForgeApp.getActivity());
						image.setScaleType(ImageView.ScaleType.CENTER);
						
						Drawable icon = null;
						if (task.params.has("prerendered") && task.params.get("prerendered").getAsBoolean()) {
							icon = BitmapUtil.scaledDrawableFromStream(ForgeApp.getActivity(), new ForgeFile(ForgeApp.getActivity(), task.params.get("icon")).fd().createInputStream(), 0, 32);
						} else {
							icon = BitmapUtil.scaledDrawableFromStreamWithTint(ForgeApp.getActivity(), new ForgeFile(ForgeApp.getActivity(), task.params.get("icon")).fd().createInputStream(), 0, 32, tint);
						}
						image.setImageDrawable(icon);
						image.setPadding(margin * 2, 1, margin * 2, 1);
						button.addView(image);
					} else {
						task.error("Invalid parameters sent to forge.topbar.addButton", "BAD_INPUT", null);
						return;
					}

					if (!(task.params.has("position") && task.params.get("position").getAsString().toLowerCase().equals("left")) && Util.right == null) {
						if (Util.right != null) {
							task.error("Button already exists in position: left", "EXPECTED_FAILURE", null);
							return;
						}
						Util.right = button;
						RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
						params.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
						params.rightMargin = Math.round(metrics.density * 9);
						params.topMargin = Math.round(metrics.density * 9);
						Util.topbar.addView(button, params);
					} else {
						if (Util.left != null) {
							task.error("Button already exists in position: right", "EXPECTED_FAILURE", null);
							return;
						}
						Util.left = button;
						RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
						params.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
						params.leftMargin = Math.round(metrics.density * 9);
						params.topMargin = Math.round(metrics.density * 9);
						Util.topbar.addView(button, params);
					}

					task.success(task.callid);
				} catch (IOException e) {
					task.error(e);
				}
			}
		});
	}

	public static void removeButtons(final ForgeTask task) {
		task.performUI(new Runnable() {
			public void run() {
				if (Util.left != null) {
					Util.topbar.removeView(Util.left);
					Util.left = null;
				}
				if (Util.right != null) {
					Util.topbar.removeView(Util.right);
					Util.right = null;
				}
				task.success();
			}
		});
	}
}