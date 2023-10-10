SCRIPT_NAME    = "weechat_shorten"
SCRIPT_AUTHOR  = "flugsio"
SCRIPT_VERSION = "0.0.1"
SCRIPT_LICENSE = "mit"
SCRIPT_DESC    = "replace stuff"

import weechat
import re

def my_modifier_cb(data, modifier, modifier_data, string):
    return re.sub(r'🛑.*https://github', 'x https://github', re.sub(r':op:.*https://github', '߂ https://github', re.sub(r':me:.*https://github', 'Ⴡ https://github', string))) \
            .replace("https://github.com/pulls?q=is:open+is:pr+user:promoteinternational+draft:false+-status:failure (active prs)", "http://r/active") \
            .replace("https://github.com/pulls?q=is:open+is:pr+user:promoteinternational+draft:true (drafts)", "http://r/drafts") \
            .replace("https://github.com/pulls?q=is:merged+is:pr+user:promoteinternational+sort:updated-desc (merged)", "http://r/merged") \
            .replace("https://github.com/promoteinternational/promote-toolbox/pull/", "http://r/gpt/") \
            .replace("https://github.com/promoteinternational/promote-release/pull/", "http://r/gpr/") \
            .replace("https://github.com/promoteinternational/promote-control-center/pull/", "http://r/gpc/") \
            .replace("https://github.com/promoteinternational/promote/pull/", "http://r/gpp/") \
            .replace("https://github.com/promoteinternational/", "http://r/gp/") \
            .replace("https://github.com/", "http://r/g/") \
            .replace("https://pivotaltracker.com/story/show/", "http://r/ps/") \
            .replace("nothing", "nothing")


weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", "")

weechat.hook_modifier("weechat_print", "my_modifier_cb", "")
