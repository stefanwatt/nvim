require("portal").setup({
    jump = {
        --- The default queries used when searching the jumplist. An entry can
        --- be a name of a registered query item, an anonymous predicate, or
        --- a well-formed query item. See Queries section for more information.
        --- @type Portal.QueryLike[]
        query = { "tagged", "modified", "different", "valid" },

        labels = {
            --- An ordered list of keys that will be used for labelling
            --- available jumps. Labels will be applied in same order as
            --- `jump.query`
            select = { "n", "e", "o", "i" },

            --- Keys which will exit portal selection
            escape = {
                ["<esc>"] = true
            },
        },

        --- Keys used for jumping forward and backward
        keys = {
            forward = "<c-i>",
            backward = "<c-o>"
        }
    },
    window = {
        title = {
            --- When a portal is empty, render an default portal title
            render_empty = true,

            --- The raw window options used for the title window
            options = {
                relative = "cursor",
                width = 80,
                height = 1,
                col = 2,
                style = "minimal",
                focusable = false,
                border = "single",
                noautocmd = true,
                zindex = 98,
            },
        },

        portal = {
            -- When a portal is empty, render an empty buffer body
            render_empty = false,

            --- The raw window options used for the portal window
            options = {
                relative = "cursor",
                width = 80,
                height = 3,
                col = 2,
                focusable = false,
                border = "single",
                noautocmd = true,
                zindex = 99,
            },
        },
    },

})
