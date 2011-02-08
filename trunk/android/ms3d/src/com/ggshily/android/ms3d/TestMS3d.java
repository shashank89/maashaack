/**
 * 
 */
package com.ggshily.android.ms3d;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

/**
 * @author cf
 * 
 */
public class TestMS3d extends Activity
{

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.main);
		
		Button btn1 = (Button) findViewById(R.id.Button01);
		btn1.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View arg0)
			{
		    	Intent result = new Intent();
		    	result.setClass(getApplication(), Graphics3D.class);
		    	result.putExtra("model", R.raw.model);
		    	result.putExtra("tex", R.raw.wood);
		    	startActivity(result);
			}
		});
		Button btn2 = (Button) findViewById(R.id.Button02);
		btn2.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View arg0)
			{
		    	Intent result = new Intent();
		    	result.setClass(getApplication(), Graphics3D.class);
		    	result.putExtra("model", R.raw.skinr);
		    	result.putExtra("tex", R.raw.skin);
		    	startActivity(result);
			}
		});
		
		/*setListAdapter(new SimpleAdapter(this, getData(),
				android.R.layout.simple_list_item_1, new String[] {"title"},
				new int[] {android.R.id.text1}));
		getListView().setTextFilterEnabled(true);*/
	}
/*
	private List<Map<String, Object>> getData()
	{
		List<Map<String, Object>> data = new ArrayList<Map<String, Object>>();
		
		Intent mainIntent = new Intent("main", null);
		mainIntent.addCategory("ms3d");
		
		PackageManager pm = getPackageManager();
		List<ResolveInfo> list = pm.queryIntentActivities(mainIntent, PackageManager.GET_META_DATA);
		
		if(null == list)
			return data;
		
		ResolveInfo info;
		int len = list.size();
		for(int i = 0; i < len; ++i)
		{
			info = list.get(i);
            CharSequence labelSeq = info.loadLabel(pm);
            String label = labelSeq != null
                    ? labelSeq.toString()
                    : info.activityInfo.name;
			
			addItem(data, label, activityIntent(info.activityInfo));
		}
		return data;
	}

    private Intent activityIntent(ActivityInfo info)
	{
    	Intent result = new Intent();
    	result.setClassName(info.packageName, info.name);
    	result.putExtra("model", info.metaData.getInt("model"));
    	result.putExtra("tex", info.metaData.getInt("tex"));
		return result;
	}

	protected void addItem(List<Map<String, Object>> data, String name, Intent intent) {
        Map<String, Object> temp = new HashMap<String, Object>();
        temp.put("title", name);
        temp.put("intent", intent);
        data.add(temp);
    }

    @SuppressWarnings("unchecked")
	@Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        Map<String, Object> map = (Map<String, Object>) l.getItemAtPosition(position);

        Intent intent = (Intent) map.get("intent");
        startActivity(intent);
    }*/
}
