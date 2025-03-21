local M = {}

M.setup = function()
  vim.api.nvim_create_user_command('W', function(opts)
    if opts.bang then
      vim.cmd('w !sudo -A tee %')
    else
      vim.cmd.write()
    end
  end, {
    bang = true,
    bar = false,
    register = false,
  })

  local function split_preserve_double_quotes(s)
    local double_quoted_strings = {}
    s = s:gsub([[%S*".-"%S*]], function(capture)
      table.insert(double_quoted_strings, capture)
      return 'PLACEHOLDER'
    end)
    local result = {}
    for word in s:gmatch('%S+') do
      if word == 'PLACEHOLDER' then
        table.insert(result, table.remove(double_quoted_strings, 1))
      else
        table.insert(result, word)
      end
    end
    return result
  end

  vim.api.nvim_create_user_command('KarateTestLine', function(o)
    local user_karate_opts
    local remove_idx
    local args = split_preserve_double_quotes(o.args)
    for idx, arg in ipairs(args) do
      user_karate_opts = string.match(arg, [==[.*^-Dkarate.options=["'](.*)["']]==])
      remove_idx = idx
    end
    if remove_idx ~= nil then
      args[remove_idx] = nil
    end
    local classpath = vim.fn.expand('%'):gsub('.*src/test/java/', 'classpath:')
    local line = vim.fn.line('.')
    local karate_options = ('%s -Dkarate.options="%s:%s %s"'):format(table.concat(args, ' '), classpath, line, user_karate_opts or '')
    local current_splitbelow = vim.o.splitbelow
    vim.o.splitbelow = true
    vim.cmd.split()
    vim.o.splitbelow = current_splitbelow
    local cmd = [[mvn test -Dtest=TestTagRunner ]] .. karate_options
    vim.notify('Running ' .. cmd, vim.log.INFO, {})
    vim.cmd.term(cmd)
    vim.cmd.normal({ 'G', bang = true })
  end, {
    bar = false,
    nargs = '*',
    register = false,
  })

  vim.api.nvim_create_user_command('KarateTestFile', function(o)
    local user_karate_opts
    local remove_idx
    local args = split_preserve_double_quotes(o.args)
    for idx, arg in ipairs(args) do
      user_karate_opts = string.match(arg, [==[.*-Dkarate.options=["'](.*)["']]==])
      remove_idx = idx
    end
    if remove_idx ~= nil then
      args[remove_idx] = nil
    end
    local classpath = vim.fn.expand('%'):gsub('.*src/test/java/', 'classpath:')
    local karate_options = ('%s -Dkarate.options="%s --tags ~@ignore %s"'):format(table.concat(args, ' '), classpath, user_karate_opts or '')
    local current_splitbelow = vim.o.splitbelow
    vim.o.splitbelow = true
    vim.cmd.split()
    vim.o.splitbelow = current_splitbelow
    local cmd = [[mvn test -Dtest=TestTagRunner ]] .. karate_options
    vim.notify('Running ' .. cmd, vim.log.INFO, {})
    vim.cmd.term(cmd)
    vim.cmd.normal({ 'G', bang = true })
  end, {
    bar = false,
    nargs = '*',
    register = false,
  })

  -- these PRs are hardcoded because they were not merged directly but in other work
  -- example command used to generate: gh pr view https://github.com/neovim/neovim/pull/25034 --json title,url,number,headRepositoryOwner,headRepository,updatedAt --jq '. | { number: .number, title: .title, url: .url, updatedAt: .updatedAt, repository: { name : "neovim", nameWithOwner: "neovim/neovim" } }'
  local pr_778 =
    '{ "number": 778, "repository": { "name": "fzf-lua", "nameWithOwner": "ibhagwan/fzf-lua" }, "title": "feat(hl): Add new FzfLuaPreviewBorder highlight", "updatedAt": "2023-06-11T07:02:02Z", "url": "https://github.com/ibhagwan/fzf-lua/pull/778" }'
  local pr_25034 =
    '{ "number": 25034, "repository": { "name": "neovim", "nameWithOwner": "neovim/neovim" }, "title": "doc: fix stderr typo", "updatedAt": "2023-09-08T12:28:34Z", "url": "https://github.com/neovim/neovim/pull/25034" }'

  vim.api.nvim_create_user_command('MGenGithubProfileContributions', function()
    local contribs = vim
      .system({
        'gh',
        'search',
        'issues',
        'is:pr',
        'is:merged',
        '--author',
        'mikesmithgh',
        '--limit',
        '1000',
        '--json',
        'repository,url,number,title,updatedAt',
        '--jq',
        '.[. |length] |= . + ' .. pr_778 .. ' | .[. |length] |= . + ' .. pr_25034 .. ' | . |= sort_by(.updatedAt) | reverse',
        '--',
        '-org:mikesmithgh',
      })
      :wait().stdout or '{}'

    -- :wait().stdout or '{}'
    local contribs_json = vim.json.decode(contribs)
    local git_merge_logo =
      [[data%3Aimage%2Fsvg%2Bxml%3Bbase64%2CPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNiIgaGVpZ2h0PSIxNiIgdmlld0JveD0iLTMgLTMgMjIgMjIiPjxnIGlkPSJkZWVkaXRvcl9iZ0NhcnJpZXIiIHN0cm9rZS13aWR0aD0iMCI%2BCiAgICA8cmVjdCBpZD0iZGVlX2NfZSIgeD0iLTMiIHk9Ii0zIiB3aWR0aD0iMjIiIGhlaWdodD0iMjIiIHJ4PSIwIiBmaWxsPSIjYTM3MWY3IiBzdHJva2V3aWR0aD0iMCIvPgogIDwvZz48cGF0aCBkPSJNNS40NSA1LjE1NEE0LjI1IDQuMjUgMCAwIDAgOS4yNSA3LjVoMS4zNzhhMi4yNTEgMi4yNTEgMCAxIDEgMCAxLjVIOS4yNUE1LjczNCA1LjczNCAwIDAgMSA1IDcuMTIzdjMuNTA1YTIuMjUgMi4yNSAwIDEgMS0xLjUgMFY1LjM3MmEyLjI1IDIuMjUgMCAxIDEgMS45NS0uMjE4Wk00LjI1IDEzLjVhLjc1Ljc1IDAgMSAwIDAtMS41Ljc1Ljc1IDAgMCAwIDAgMS41Wm04LjUtNC41YS43NS43NSAwIDEgMCAwLTEuNS43NS43NSAwIDAgMCAwIDEuNVpNNSAzLjI1YS43NS43NSAwIDEgMCAwIC4wMDVWMy4yNVoiIGZpbGw9IiNmZmZmZmYiLz48L3N2Zz4%3D]]
    local bufid = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(bufid)
    local result = {
      [[<table>]],
    }
    local icons = {
      ['digitalocean/openapi'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/ec985f90-6d8b-40aa-8d31-04636b9269f9',
      ['digitalocean/godo'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/ec985f90-6d8b-40aa-8d31-04636b9269f9',
      ['digitalocean/doctl'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/b1fd81e6-e93b-4f43-9a24-343f72886ff9',
      ['neovim/neovim'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/e716367a-2b0f-4e60-aad9-2f413887239b',
      ['ibhagwan/fzf-lua'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/8fcedac6-a63d-4f00-a0e5-967949fe18f4',
      ['junegunn/fzf'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/a20caf41-7d96-4dd7-9589-d9479d8a931e',
      ['derailed/k9s'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/c9ca23b7-411d-4d95-966e-700c1bc99585',
      ['ellisonleao/gruvbox.nvim'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/f37f9c84-3463-4de8-8d03-4c6490f379f1',
      ['rockerBOO/awesome-neovim'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/44b2ee30-9ee5-4e67-bb39-851eb76aedb5',
      ['letsencrypt/boulder'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/ddbb3b6e-d251-4c22-8afb-0bf458f645a8',
      ['kovidgoyal/kitty'] = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/fe100777-42ac-493d-85f6-948a2d13b53e',
    }

    local emojis = {
      ['folke/noice.nvim'] = '💥',
      ['folke/lazy.nvim'] = '💤',
      ['folke/zen-mode.nvim'] = '🧘',
      ['Homebrew/homebrew-cask'] = '🍺',
    }

    local extra_icons = {
      ['hacktoberfest_icon'] = {
        src = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/52ca9bf0-2328-43bd-b8d1-5609219641a3',
        alt = 'hacktoberfest 2023',
      },
      ['https://github.com/m4xshen/hardtime.nvim/pull/59'] = {
        src = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/2dfb0b86-bf99-4f24-8e80-9fbf37c9e66e',
        alt = 'hacktoberfest 2023',
        href = 'https://www.holopin.io/hacktoberfest2023/userbadge/clnlwbn9425930fl7wnbeofib',
      },
      ['https://github.com/digitalocean/openapi/pull/828'] = {
        src = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/7bfa650b-67ea-4ff5-acd8-72d265d28c55',
        alt = 'hacktoberfest 2023',
        href = 'https://www.holopin.io/hacktoberfest2023/userbadge/clnt1bf8j225560fl0p2o331n5',
      },
      ['https://github.com/digitalocean/godo/pull/637'] = {
        src = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/0ae9fb09-3c35-4c29-9fe8-d2ed50692490',
        alt = 'hacktoberfest 2023',
        href = 'https://www.holopin.io/hacktoberfest2023/userbadge/clnup025v236220flctpfpz1gr',
      },
      ['https://github.com/digitalocean/doctl/pull/1431'] = {
        src = 'https://github.com/mikesmithgh/mikesmithgh/assets/10135646/61173ffa-b57a-4fec-8159-746ce5b95e47',
        alt = 'hacktoberfest 2023',
        href = 'https://www.holopin.io/hacktoberfest2023/userbadge/clnwdajuv150010gjsx4ew1ujw',
      },
    }

    for _, pr in pairs(contribs_json) do
      local repo_url = pr.url:gsub('/[^/]+$', ''):gsub('/[^/]+$', '')
      local repo = pr.repository.nameWithOwner
      table.insert(result, [[  <tr>]])
      table.insert(
        result,
        [[    <td><a href="]]
          .. pr.url
          .. [["><img alt="]]
          .. pr.number
          .. [["  height="25px" src="https://img.shields.io/badge/]]
          .. vim.uri_encode(pr.title:gsub('-', '--'))
          .. vim.uri_encode(' #' .. pr.number)
          .. [[-070707?style=flat-square&logo=]]
          .. git_merge_logo
          .. [[&label=%20&labelColor=a371f7&color=070707"></a></td>]]
      )

      local extra_icon = ''
      if extra_icons[pr.url] then
        extra_icon = [[<a href="]]
          .. extra_icons[pr.url].href
          .. [["> <picture> <source media="(prefers-color-scheme: dark)" srcset="]]
          .. extra_icons[pr.url].src
          .. [["> <source media="(prefers-color-scheme: light)" srcset="]]
          .. extra_icons[pr.url].src
          .. [["> <img height="16px" alt="]]
          .. extra_icons[pr.url].alt
          .. [[" src="]]
          .. extra_icons[pr.url].src
          .. [["> </picture> </a> ]]
      end

      if extra_icon == '' and not icons[repo] and not emojis[repo] then
        table.insert(result, [[    <td colspan=2 ><a href="]] .. repo_url .. [[">]] .. repo .. [[</a></td>]])
      else
        table.insert(result, [[    <td><a href="]] .. repo_url .. [[">]] .. repo .. [[</a></td>]])
      end
      if icons[repo] then
        table.insert(
          result,
          [[    <td align="center" nowrap ><a href="]]
            .. repo_url
            .. [["> <picture> <source media="(prefers-color-scheme: dark)" srcset="]]
            .. icons[repo]
            .. [["> <source media="(prefers-color-scheme: light)" srcset="]]
            .. icons[repo]
            .. [["> <img height="16px" alt="]]
            .. repo
            .. [[" src="]]
            .. repo_url
            .. [["> </picture> </a>]]
            .. extra_icon
            .. [[ </td>]]
        )
      elseif emojis[repo] then
        table.insert(result, [[    <td align="center" nowrap ><a href="]] .. repo_url .. [[">]] .. emojis[repo] .. extra_icon .. [[ </td>]])
      elseif extra_icon ~= '' then
        table.insert(result, [[    <td align="center" >]] .. extra_icon .. [[</td>]])
      end
      table.insert(result, [[  </tr>]])
    end
    table.insert(result, [[</table>]])
    vim.api.nvim_buf_set_lines(bufid, 0, -1, false, result)
    vim.api.nvim_set_option_value('filetype', 'markdown', {
      buf = bufid,
    })
  end, {
    bar = false,
    register = false,
  })

  vim.api.nvim_create_user_command('FormatJira', function()
    local issue_id = vim.fn.expand('<cWORD>'):match('FTE%-%d+')
    if issue_id == nil then
      issue_id = vim.fn.expand('<cWORD>'):match('^%d+$')
      issue_id = issue_id and 'FTE-' .. issue_id
    end
    if issue_id == nil then
      issue_id = vim.fn.expand('<cWORD>'):match('^%d+$')
      vim.notify('could not parse Jira issue ID', vim.log.levels.ERROR, {})
      return
    end
    local issue = vim
      .system({
        'curl',
        '--user',
        vim.env.JIRA_API_USER .. ':' .. vim.env.JIRA_API_TOKEN,
        '--header',
        'Accept: application/json',
        vim.env.JIRA_API_URL .. '/rest/api/3/issue/' .. issue_id .. '?fields=summary',
      })
      :wait().stdout or '{}'

    local issue_json = vim.json.decode(issue)
    local issue_link = vim.env.JIRA_API_URL .. '/browse/' .. issue_json.key
    vim.cmd.normal({ 'mmciW{' .. issue_link .. '}[' .. issue_json.key .. ' ' .. issue_json.fields.summary .. ']', bang = true })
    vim.cmd.normal({ '0`m', bang = true })
  end, {
    bar = false,
    register = false,
  })

  vim.api.nvim_create_user_command('TermHl', function()
    local b = vim.api.nvim_create_buf(false, true)
    local chan = vim.api.nvim_open_term(b, {})
    vim.api.nvim_chan_send(chan, table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
    vim.api.nvim_win_set_buf(0, b)
  end, { desc = 'Highlights ANSI termcodes in curbuf' })
end

return M
