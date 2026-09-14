| Step  | Description                                                                     | Result | Reason                                                  |
|-------|---------------------------------------------------------------------------------|--------|---------------------------------------------------------|
| 0     | Naive count                                                                     | 30     | starting point                                          |
| 1     | Exclude campaign 9004 (creation_status='approval_awaiting')                     | 26     | Not yet approved - doesn't count as per README          |
| 2     | Collapse duplicate customers within retry chains (9001->9002->9003, 9201->9202) | 22     | Retry = same communication re-attempted, not a new send |
| final |                                                                                 | 22     |                                                         |
