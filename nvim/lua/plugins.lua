function packer_startup(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- lsp manager
  -- use 'williamboman/mason.nvim'
  -- use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
end

require('packer').startup(packer_startup)
-- require('mason').setup()

require('lspconfig').rust_analyzer.setup({})
