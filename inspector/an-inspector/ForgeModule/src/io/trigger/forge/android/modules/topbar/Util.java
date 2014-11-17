package io.trigger.forge.android.modules.topbar;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeFile;
import io.trigger.forge.android.util.BitmapUtil;

import java.io.IOException;

import com.google.gson.JsonElement;

import android.app.Activity;
import android.content.Context;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class Util {
	public static RelativeLayout topbar = null;
	public static View title = null;
	public static TextView titleText = null;
	public static LinearLayout left = null;
	public static LinearLayout right = null;

	public static void setTitle(Context context, String text) {
		DisplayMetrics metrics = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(metrics);

		titleText = new TextView(context);
		titleText.setText(text);
		titleText.setTextColor(0xFF000000);
		titleText.setTextSize(TypedValue.COMPLEX_UNIT_PX, metrics.density * 24);
		titleText.setGravity(Gravity.CENTER);

		RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(10000, 10000);
		topbar.addView(titleText, params);
		topbar.removeView(title);
		title = titleText;
	}

	public static void setTitleImage(Context context, JsonElement icon) throws IOException {
		ImageView newtitle = new ImageView(context);
		newtitle.setScaleType(ImageView.ScaleType.CENTER);
		
		newtitle.setImageDrawable(BitmapUtil.scaledDrawableFromStream(context, new ForgeFile(ForgeApp.getActivity(), icon).fd().createInputStream(), 0, 50));

		RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(10000, 10000);
		topbar.addView(newtitle, params);
		topbar.removeView(title);
		title = newtitle;
	}
}
