require './controllers/tagcontroller.rb'
require './models/tag'

describe TagController do
    describe 'get_top_5_tag' do
        context "when get_top_5_tag" do   
            it 'Tag should call get_top_5' do
                expect(Tag).to receive(:get_top_5)
                TagController.get_top_5_tag
            end
        end
    end
end
