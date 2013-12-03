package io.trigger.forge.android.modules.topbar;

import io.trigger.forge.android.core.ForgeApp;
import io.trigger.forge.android.core.ForgeEventListener;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class EventListener extends ForgeEventListener {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		RelativeLayout topbar = new RelativeLayout(ForgeApp.getActivity());

		int size = 50;
		DisplayMetrics metrics = new DisplayMetrics();
		ForgeApp.getActivity().getWindowManager().getDefaultDisplay().getMetrics(metrics);
		int requiredSize = Math.round(metrics.density * size);

		topbar.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, requiredSize));
		topbar.setGravity(Gravity.CENTER);

		ColorDrawable bgColor = new ColorDrawable(0xFFEEEEEE);
		topbar.setBackgroundDrawable(bgColor);

		ForgeApp.getActivity().mainLayout.addView(topbar, 0);
		ForgeApp.getActivity().mainLayout.setBackgroundColor(0xFFFFFFFF);

		// Add default title
		TextView title = new TextView(ForgeApp.getActivity());
		if (ForgeApp.appConfig.has("name")) {
			title.setText(ForgeApp.appConfig.get("name").getAsString());
		}
		title.setTextColor(0xFF000000);
		title.setTextSize(TypedValue.COMPLEX_UNIT_PX, metrics.density * 24);
		title.setGravity(Gravity.CENTER);
		RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(10000, 10000);
		topbar.addView(title, params);

		// Save references
		Util.left = null;
		Util.right = null;
		Util.topbar = topbar;
		Util.title = title;
	}
}
