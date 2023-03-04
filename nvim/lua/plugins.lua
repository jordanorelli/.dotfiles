function packer_startup(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lsp manager
  use 'neovim/nvim-lspconfig'
end

require('packer').startup(packer_startup)

require('lspconfig').rust_analyzer.setup({})
