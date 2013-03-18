---
layout: page
title: mewmew  ~ meow ~
---
{% include JB/setup %}

<section>
  <h1>Recent Posts</h1>
  <ul id="recent_posts">
    {% for post in site.posts limit: 30 %}
      <li class="post">
	<a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
</section>

