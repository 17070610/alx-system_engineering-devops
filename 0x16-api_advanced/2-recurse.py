#!/usr/bin/python3
import requests

def recurse(subreddit, hot_list=[], after=None):
    """
    Recursively fetches hot article titles from a given subreddit.
    
    Args:
        subreddit (str): The name of the subreddit.
        hot_list (list): List to store hot article titles (used for recursion).
        after (str): Token for pagination (used for recursion).
    
    Returns:
        list: List of hot article titles, or None if subreddit is invalid.
    """
    url = f"https://www.reddit.com/r/{subreddit}/hot.json"
    headers = {"User-Agent": "Mozilla/5.0"}
    params = {"limit": 100, "after": after}

    response = requests.get(url, headers=headers, params=params, allow_redirects=False)

    # If subreddit is invalid or restricted (Reddit returns a 404 or 302 redirect)
    if response.status_code != 200:
        return None

    data = response.json()
    posts = data.get("data", {}).get("children", [])
    
    # Append the titles of posts to the hot_list
    for post in posts:
        hot_list.append(post["data"]["title"])
    
    # Get the 'after' token for pagination
    after = data.get("data", {}).get("after")

    # If there's more data, recursively call the function
    if after:
        return recurse(subreddit, hot_list, after)

    return hot_list
