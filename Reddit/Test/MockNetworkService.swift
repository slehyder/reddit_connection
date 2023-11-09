//
//  MockNetworkService.swift
//  Reddit
//
//  Created by Slehyder Martinez on 8/11/23.
//

import Foundation

class MockNetworkService: NetworkServiceProvider {
    
    var mockResponse: Data?
    var mockError: ErrorModel?
    
    func request<T: IEndpoint, D: Codable>(endpoint: T, decodeType: D.Type, completion: @escaping (Result<D?, ErrorModel>) -> Void) {
    
        if let mockResponse = mockResponse {
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(decodeType, from: mockResponse)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.parse(error)))
            }
        } else if let mockError = mockError {
            completion(.failure(mockError))
        } else {
            completion(.success(nil))
        }
    }
    
    func configureMock(response: Data?) {
        self.mockResponse = response
    }
    
    func configureMock(error: ErrorModel?) {
        self.mockError = error
    }
    
    static let jsonMockSuccessResponseString = """
        {
          "kind": "Listing",
          "data": {
            "modhash": "1w2qn6lwyl99579a9b4bf855f0c845bc69cd7f882c2d8f5229",
            "dist": 1,
            "facets": {},
            "after": "t3_15au2sc",
            "geo_filter": "",
            "children": [
              {
                "kind": "t3",
                "data": {
                  "approved_at_utc": null,
                  "subreddit": "Veterans",
                  "selftext": "I have just read an article in the Stars and Stripes about an Army veteran who pleaded guilty to stealing over $100,000 in disability benefits by exaggerating the severity of his medical conditions.\\n\\nThis guy has lied to VA medical examiners that he had a degenerative disc and arthritis that prevented him from bending, squatting, or lifting more than 25 lbs above his shoulders. So, the VA updated his disability rating and paid him accordingly. Trouble started when he applied for Social Security benefits.\\n\\nOn the day of his disability hearing for his Social Security benefits, Federal agents observed him walking without difficulty while carrying heavy trash bags. But while walking to his hearing for Social Security benefits, he used a cane and walked at a much slower pace. He has also posted videos on his Instagram account showing him lifting heavy weights and his workout regimen included deep squats and leg presses. Oh, and on his website, he bills himself as a personal trainer. \\n\\nHis sentencing is scheduled for October 25. The VA has reduced his disability percentage and ordered him to pay back the money he stole.\\n\\n&#x200B;",
                  "author_fullname": "t2_bl5zfxrgr",
                  "saved": false,
                  "mod_reason_title": null,
                  "gilded": 0,
                  "clicked": false,
                  "title": "VA Disability Fakers",
                  "link_flair_richtext": [],
                  "subreddit_name_prefixed": "r/Veterans",
                  "hidden": false,
                  "pwls": 7,
                  "link_flair_css_class": "",
                  "downs": 0,
                  "thumbnail_height": null,
                  "top_awarded_type": null,
                  "hide_score": false,
                  "name": "t3_15au2sc",
                  "quarantine": false,
                  "link_flair_text_color": "light",
                  "upvote_ratio": 0.94,
                  "author_flair_background_color": "#0079d3",
                  "subreddit_type": "public",
                  "ups": 366,
                  "total_awards_received": 0,
                  "media_embed": {},
                  "thumbnail_width": null,
                  "author_flair_template_id": "3085c1b0-bab5-11ed-83f6-4a656dc15192",
                  "is_original_content": false,
                  "user_reports": [],
                  "secure_media": null,
                  "is_reddit_media_domain": false,
                  "is_meta": false,
                  "category": null,
                  "secure_media_embed": {},
                  "link_flair_text": "VA Disability",
                  "can_mod_post": false,
                  "score": 366,
                  "approved_by": null,
                  "is_created_from_ads_ui": false,
                  "author_premium": false,
                  "thumbnail": "self",
                  "edited": false,
                  "author_flair_css_class": null,
                  "author_flair_richtext": [],
                  "gildings": {},
                  "content_categories": null,
                  "is_self": true,
                  "mod_note": null,
                  "created": 1690439533.0,
                  "link_flair_type": "text",
                  "wls": 7,
                  "removed_by_category": null,
                  "banned_by": null,
                  "author_flair_type": "text",
                  "domain": "self.Veterans",
                  "allow_live_comments": true,
                  "selftext_html": "&lt;!-- SC_OFF --&gt;&lt;div class=\\"md\\"&gt;&lt;p&gt;I have just read an article in the Stars and Stripes about an Army veteran who pleaded guilty to stealing over $100,000 in disability benefits by exaggerating the severity of his medical conditions.&lt;/p&gt;\\n\\n&lt;p&gt;This guy has lied to VA medical examiners that he had a degenerative disc and arthritis that prevented him from bending, squatting, or lifting more than 25 lbs above his shoulders. So, the VA updated his disability rating and paid him accordingly. Trouble started when he applied for Social Security benefits.&lt;/p&gt;\\n\\n&lt;p&gt;On the day of his disability hearing for his Social Security benefits, Federal agents observed him walking without difficulty while carrying heavy trash bags. But while walking to his hearing for Social Security benefits, he used a cane and walked at a much slower pace. He has also posted videos on his Instagram account showing him lifting heavy weights and his workout regimen included deep squats and leg presses. Oh, and on his website, he bills himself as a personal trainer. &lt;/p&gt;\\n\\n&lt;p&gt;His sentencing is scheduled for October 25. The VA has reduced his disability percentage and ordered him to pay back the money he stole.&lt;/p&gt;\\n\\n&lt;p&gt;&amp;#x200B;&lt;/p&gt;\\n&lt;/div&gt;&lt;!-- SC_ON --&gt;",
                  "likes": null,
                  "suggested_sort": null,
                  "banned_at_utc": null,
                  "view_count": null,
                  "archived": false,
                  "no_follow": false,
                  "is_crosspostable": true,
                  "pinned": false,
                  "over_18": false,
                  "all_awardings": [],
                  "awarders": [],
                  "media_only": false,
                  "link_flair_template_id": "9dd9e97e-be5e-11e8-80ba-0e0c129bb2a8",
                  "can_gild": false,
                  "spoiler": false,
                  "locked": false,
                  "author_flair_text": "US Army Retired",
                  "treatment_tags": [],
                  "visited": false,
                  "removed_by": null,
                  "num_reports": null,
                  "distinguished": null,
                  "subreddit_id": "t5_2rc75",
                  "author_is_blocked": false,
                  "mod_reason_by": null,
                  "removal_reason": null,
                  "link_flair_background_color": "#46d160",
                  "id": "15au2sc",
                  "is_robot_indexable": true,
                  "report_reasons": null,
                  "author": "land-1000-hills",
                  "discussion_type": null,
                  "num_comments": 279,
                  "send_replies": true,
                  "whitelist_status": "some_ads",
                  "contest_mode": false,
                  "mod_reports": [],
                  "author_patreon_flair": false,
                  "author_flair_text_color": "light",
                  "permalink": "/r/Veterans/comments/15au2sc/va_disability_fakers/",
                  "parent_whitelist_status": "some_ads",
                  "stickied": false,
                  "url": "https://www.reddit.com/r/Veterans/comments/15au2sc/va_disability_fakers/",
                  "subreddit_subscribers": 116993,
                  "created_utc": 1690439533.0,
                  "num_crossposts": 0,
                  "media": null,
                  "is_video": false
                }
              }
            ],
            "before": null
          }
        }
        """
}
