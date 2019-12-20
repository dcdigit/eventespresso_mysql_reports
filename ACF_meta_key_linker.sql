SELECT 

wpm.post_id
, wpm.meta_key
, wpm.meta_value
, concat("<a href='/wp-admin/admin.php?page=espresso_events&action=edit&post=", wpm.post_id, "' target='_blank'>", wpm.post_id, '_', wpm.meta_key, '_', wpm.meta_value, "</a>") POST_URL

FROM wp_postmeta wpm 

WHERE 1=1
and wpm.meta_key REGEXP 'your_meta_key_regexp_here' 
and wpm.meta_value != ''

ORDER BY wpm.post_id, wpm.meta_id
