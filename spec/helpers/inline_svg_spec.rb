require 'inline_svg'
require 'nokogiri'
require 'active_support/core_ext'

describe InlineSvg::ActionView::Helpers do

  before(:each) do
    # Mock Rails
    unless defined?(::Rails)
      @mocked_rails_class = true
      class ::Rails
      end
    end
    # Allow mock Rails to give a path to our SVG
    path_mocker = double("path_mocker")
    allow(path_mocker).to receive(:join) { 'spec/files/example.svg' }
    allow(Rails).to receive(:root) { path_mocker }
  end

  let(:mock_helper) { ( Class.new { include InlineSvg::ActionView::Helpers } ).new }

  describe "#inline_svg" do
    
    context 'when passed a SVG file' do
      
      subject { mock_helper.inline_svg( 'mocked_path' ).strip }
      let(:example_svg) {
<<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><!-- This is a comment --></svg>
SVG
      }
      
      it { is_expected.to eql example_svg }
      
      context 'and title and description options' do
      
        subject { mock_helper.inline_svg( 'mocked_path', title: 'A title', desc: 'A desc' ).strip }
        let(:example_svg) {
<<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" role="presentation" xml:lang="en"><!-- This is a comment --><title>A title</title>
<desc>A desc</desc></svg>
SVG
        }
        
        it { is_expected.to eql example_svg }
      
      end

      context 'and the "nocomment" option' do

        subject { mock_helper.inline_svg( 'mocked_path', nocomment: true).strip }
        let(:example_svg) {
<<-SVG.sub(/\n$/, '')
<svg xmlns="http://www.w3.org/2000/svg" xml:lang="en"></svg>
SVG
        }

        it { is_expected.to eql example_svg }

      end
    end
  end
end