# Looker View: Combined Amazon DSP GSheet Data
# --------------------------------------------
# This view combines two separate GSheets (split due to data size limits) into one reporting table.
# Enables unified analysis of historical Amazon DSP performance from Jan 2023 to present.

view: amazon_dsp_jan01_2023_to_current_gsheet {
  derived_table: {
    sql:
      SELECT * FROM DAASITY_DB.AMAZON_DSP_JAN01_2023_TO_DEC31_2024.GSHEETS
      UNION ALL
      SELECT * FROM DAASITY_DB.AMAZON_DSP_JAN01_2025_TO_CURRENT.GSHEETS ;;
  }

  dimension: id { type: string; sql: ${TABLE}.id ;; }
  dimension: activity_date { type: date; sql: ${TABLE}.activity_date ;; }
  dimension: store { type: string; sql: ${TABLE}.store ;; }
  dimension: channel { type: string; sql: ${TABLE}.channel ;; }
  dimension: vendor { type: string; sql: ${TABLE}.vendor ;; }
  dimension: subchannel { type: string; sql: ${TABLE}.subchannel ;; }
  dimension: media_type { type: string; sql: ${TABLE}.media_type ;; }
  dimension: ad_account_id { type: string; sql: ${TABLE}.ad_account_id ;; }
  dimension: ad_account_name { type: string; sql: ${TABLE}.ad_account_name ;; }
  dimension: property_name { type: string; sql: ${TABLE}.property_name ;; }
  dimension: network_type { type: string; sql: ${TABLE}.network_type ;; }
  dimension: campaign_id { type: string; sql: ${TABLE}.campaign_id ;; }
  dimension: campaign_name { type: string; sql: ${TABLE}.campaign_name ;; }
  dimension: campaign_status { type: string; sql: ${TABLE}.campaign_status ;; }
  dimension: adset_id { type: string; sql: ${TABLE}.adset_id ;; }
  dimension: adset_name { type: string; sql: ${TABLE}.adset_name ;; }
  dimension: adset_status { type: string; sql: ${TABLE}.adset_status ;; }
  dimension: ad_id { type: string; sql: ${TABLE}.ad_id ;; }
  dimension: ad_name { type: string; sql: ${TABLE}.ad_name ;; }
  dimension: ad_description { type: string; sql: ${TABLE}.ad_description ;; }
  dimension: ad_url { type: string; sql: ${TABLE}.ad_url ;; }
  dimension: ad_status { type: string; sql: ${TABLE}.ad_status ;; }

  measure: total_spend { type: sum; sql: ${TABLE}.total_spend ;; value_format_name: usd_0 }
  measure: total_clicks { type: sum; sql: ${TABLE}.total_clicks ;; }
  measure: total_impressions { type: sum; sql: ${TABLE}.total_impressions ;; }
  measure: vendor_reported_orders { type: sum; sql: ${TABLE}.vendor_reported_orders ;; }
  measure: vendor_reported_revenue { type: sum; sql: ${TABLE}.vendor_reported_revenue ;; }

  dimension: keyword { type: string; sql: ${TABLE}.keyword ;; }
  measure: revenue_clickthrough { type: sum; sql: ${TABLE}.revenue_clickthrough ;; }
  measure: revenue_viewthrough { type: sum; sql: ${TABLE}.revenue_viewthrough ;; }
  measure: purchases_clickthrough { type: sum; sql: ${TABLE}.purchases_clickthrough ;; }
  measure: purchases_viewthrough { type: sum; sql: ${TABLE}.purchases_viewthrough ;; }

  dimension: segment_1 { type: string; sql: ${TABLE}.segment_1 ;; }
  dimension: segment_2 { type: string; sql: ${TABLE}.segment_2 ;; }
  dimension: segment_3 { type: string; sql: ${TABLE}.segment_3 ;; }
  dimension: segment_4 { type: string; sql: ${TABLE}.segment_4 ;; }
  dimension: segment_5 { type: string; sql: ${TABLE}.segment_5 ;; }

  measure: video_views { type: sum; sql: ${TABLE}.video_views ;; }
  measure: video_views_pct_25 { type: sum; sql: ${TABLE}.video_views_pct_25 ;; }
  measure: video_views_pct_50 { type: sum; sql: ${TABLE}.video_views_pct_50 ;; }
  measure: video_views_pct_75 { type: sum; sql: ${TABLE}.video_views_pct_75 ;; }
  measure: video_views_pct_100 { type: sum; sql: ${TABLE}.video_views_pct_100 ;; }

  dimension: original_currency { type: string; sql: ${TABLE}.original_currency ;; }
  measure: currency_conversion_rate { type: average; sql: ${TABLE}.currency_conversion_rate ;; }
  dimension: target_currency { type: string; sql: ${TABLE}.target_currency ;; }
}
