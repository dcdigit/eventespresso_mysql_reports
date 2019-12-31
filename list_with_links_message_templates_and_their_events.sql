select 

CASE 
	when wemtg.MTP_name = '' then 'Global Attendee Template'
	else wemtg.MTP_name
end template_name
, CASE 
	when wemtg.MTP_description = '' then 'Global Attendee Template used for most registrations AND for when a customer buys multiple items in one transaction. It has Advanced Custom Fields EVENT_META_* shortcodes and also custom shortcodes for handling each type of registration.'
	else wemtg.MTP_description
end template_description
, concat("<a href='/wp-admin/admin.php?page=espresso_messages&action=edit_message_template&context=attendee&id=", wemtg.GRP_ID, "' target='_blank'>", wemt.MTP_content, "</a>") MESSAGE_URL
, wemtg.MTP_is_global
, concat("<a href='/wp-admin/admin.php?page=espresso_events&action=edit&post=", wpe.id, "' target='_blank'>", wpe.post_title, "</a>") POST_URL
, max(wed.DTT_EVT_end) final_event_datetime

from wp_esp_message_template_group wemtg

join wp_esp_event_message_template weemt on weemt.GRP_ID = wemtg.GRP_ID
join wp_esp_message_template wemt on wemt.GRP_ID = wemtg.GRP_ID
join wp_posts wpe on wpe.id = weemt.EVT_ID 
join wp_esp_datetime wed on wed.EVT_ID = wpe.id

where 1=1
and wemtg.MTP_message_type = 'registration'
and wemt.MTP_context = 'attendee'
and wemt.MTP_template_field = 'subject'
and wemtg.MTP_deleted = 0
and wemtg.MTP_is_active = 1
and wpe.post_status = 'publish'
and wed.DTT_EVT_end > now()

group by wemtg.GRP_ID, weemt.EVT_ID
order by wemtg.MTP_is_global
