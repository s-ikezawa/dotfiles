-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
return {
  settings = {
    gopls = {
      -- Build
      buildFlags = {},
      -- env = {}, -- nvalid type []interface {} (want JSON object)
      directoryFilters = { "-**/node_modules" },
      templateExtensions = {},
      -- memoryMode = "", this setting is deprecated;
      expandWorkspaceToModule = true,
      standaloneTags = { "ignore" },
      -- workspaceFiles = {}, "workspaceFiles": unexpected setting
      -- Formatting
      -- local = "", -- luaの定義ずみ変数名となっておりエラーになるのでコメントアウト
      gofumpt = false,
      -- UI
      codelenses = {
        generate = true,
        regenerate_cgo = true,
        test = true, -- default: off
        run_govulncheck = false,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
        vulncheck = false,
      },
      semanticTokens = false,
      noSemanticString = false,
      noSemanticNumber = false,
      -- semanticTokenTypes = {}, -- "semanticTokenTypes": unexpected setting
      -- semanticTokenModifiers = {}, "semanticTokenModifiers": unexpected setting;
      -- Completion
      usePlaceholders = true, -- default: false
      completionBudget = "100ms",
      matcher = "Fuzzy", -- CaseInsensitive, CaseSesitive, Fuzzy (default Fuzzy)
      experimentalPostfixCompletions = true,
      completeFunctionCalls = true,
      -- Diagnostic
      analyses = {
        appends = true,
        asmdecl = true,
        assign = true,
        atomic = true,
        atomicalign = true,
        bools = true,
        buildtag = true,
        cgocall = true,
        composites = true,
        copylocks = true,
        deepequalerrors = true,
        defers = true,
        deprecated = true,
        directive = true,
        embed = true,
        errorsas = true,
        fillreturns = true,
        framepointer = true,
        hostport = true,
        httpresponse = true,
        ifaceassert = true,
        infertypeargs = true,
        inline = true,
        loopclosure = true,
        lostcancel = true,
        modernize = true,
        nilfunc = true,
        nilness = true,
        nonewvars = true,
        noresultvalues = true,
        printf = true,
        shadow = true,
        shift = true,
        sigchanyzer = true,
        simplifycompositelit = true,
        simplifyrange = true,
        simplifyslice = true,
        slog = true,
        sortslice = true,
        stdmethods = true,
        stdversion = true,
        stringintconv = true,
        structtag = true,
        testinggoroutine = true,
        test = true,
        timeformat = true,
        unmarshal = true,
        unreachable = true,
        unsafeptr = true,
        unusedfunc = true,
        unusedparams = true,
        unusedresult = true,
        unusedvariable = true,
        unusedwrite = true,
        waitgroup = true,
        yield = true,
      },
      staticcheck = false,
      vulncheck = "Off", -- Imports, Off (default Off)
      diagnosticsDelay = "1s",
      diagnosticsTrigger = "Edit", -- Edit, Save
      analysisProgressReporting = true,
      -- Documentation
      hoverKind = "FullDocumentation", -- FullDocumentation, NoDocumentation, SingleLine, SynopsisDocumentation
      linkTarget = "pkg.go.dev", -- eg. godoc.org pkg.go.dev
      linksInHover = true, -- false, true, gopls
      -- Inlayhint this setting is experimental and may be deleted
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      -- Navigation
      importShortcut = "Both", -- Both, Definition, Link
      symbolMatcher = "FastFuzzy", -- CaseInsensitive, CaseSensitive, FastFuzzy, Fuzzy
      symbolStyle = "Dynamic", -- Dynamic, Full, Package
      symbolScope = "all", -- all, workspace
      verboseOutput = false,
    },
  },
}
