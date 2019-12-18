select

weli.LIN_timestamp promotion_redeemed_timestamp
, weli.LIN_desc promo_desc

, case 
	when (weli.LIN_percent != 0) then round((weli.LIN_percent * 0.01 * welip.LIN_unit_price),2) 
	else weli.LIN_unit_price
end discount_unit

, welip.LIN_total product_total

, wet.TXN_total transaction_total
, weli.LIN_total promotion_total

, wpa.post_title attendee_name
, concat("<a href='?page=espresso_registrations&action=view_registration&_REG_ID=", wer.REG_ID, "' target='_blank'>", wpe.post_title,"</a>") REG_URL

from wp_esp_line_item weli

join wp_esp_transaction wet on wet.TXN_ID = weli.TXN_ID and (weli.OBJ_type = "Promotion")
join wp_esp_registration wer on wer.TXN_ID = wet.TXN_ID
join wp_posts wpe on wpe.id = wer.EVT_ID
join wp_esp_line_item welip on welip.TXN_ID = wer.TXN_ID and (welip.OBJ_type = 'Price' and welip.LIN_total > 0)

join wp_posts wpa on wpa.id = wer.ATT_ID

where 1=1
and wer.STS_ID = 'RAP'

group by wet.TXN_ID

order by weli.LIN_timestamp desc
