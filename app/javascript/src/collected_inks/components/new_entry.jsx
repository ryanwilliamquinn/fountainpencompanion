import * as React from "react";
import { connect } from "react-redux";

import { addEntry } from "src/collected_inks/actions";

import Brand from "./row/brand";
import Privacy from "./row/privacy";
import Line from "./row/line";
import Ink from "./row/ink";
import Kind from "./row/kind";
import Color from "./row/color";
import Swabbed from "./row/swabbed";
import Used from "./row/used";
import Comment from "./row/comment";
import Maker from "./row/maker";

class NewEntry extends React.Component {

  constructor(props) {
    super(props)
    this.state = this.emptyState()
  }

  emptyState() {
    return {
      private: false,
      brand_name: '',
      line_name: '',
      ink_name: '',
      kind: '',
      color: '',
      swabbed: false,
      used: false,
      comment: '',
      archived: false,
      maker: ''
    };
  }

  onReset = () => {
    this.setState(this.emptyState())
  }

  isValid() {
    return this.state.brand_name && this.state.ink_name;
  }

  onSaveClicked = () => {
    if (!this.isValid()) return;
    this.props.onSave(this.state)
    this.onReset();
  }

  onTogglePrivacy = () => {
    this.setState({private: !this.state.private})
  }

  onChangeBrand = (value) => {
    this.setState({brand_name: value})
  }

  onChangeLine = (value) => {
    this.setState({line_name: value})
  }

  onChangeInk = (value) => {
    this.setState({ink_name: value})
  }

  onChangeKind = (value) => {
    this.setState({kind: value})
  }

  onChangeColor = (value) => {
    this.setState({color: value})
  }

  onToggleSwabbed = () => {
    this.setState({swabbed: !this.state.swabbed})
  }

  onToggleUsed = () => {
    this.setState({used: !this.state.used})
  }

  onChangeComment = (value) => {
    this.setState({comment: value})
  }

  onChangeMaker = (value) => {
    this.setState({maker: value})
  }

  render() {
    const state = this.state;
    return <tr>
      <td><Privacy private={state.private} onClick={this.onTogglePrivacy} /></td>
      <td className="new-entry"><Brand onlyEdit brand={state.brand_name} onChange={this.onChangeBrand}/></td>
      <td className="new-entry"><Line onlyEdit line={state.line_name} onChange={this.onChangeLine} /></td>
      <td className="new-entry"><Ink onlyEdit ink={state.ink_name} onChange={this.onChangeInk} /></td>
      <td className="new-entry"><Maker onlyEdit maker={state.maker} onChange={this.onChangeMaker} /></td>
      <td><Kind kind={state.kind} onChange={this.onChangeKind}/></td>
      <td><Color color={state.color} onChange={this.onChangeColor}/></td>
      <td><Swabbed swabbed={state.swabbed} onClick={this.onToggleSwabbed}/></td>
      <td><Used used={state.used} onClick={this.onToggleUsed}/></td>
      <td></td>
      <td className="new-entry"><Comment onlyEdit comment={state.comment} onChange={this.onChangeComment}/></td>
      <td>
        <a onClick={this.onSaveClicked} className="btn btn-default">
          <i className="fa fa-check" />
        </a>
        <a onClick={this.onReset} className="btn btn-default">
          <i className="fa fa-close" />
        </a>
      </td>
    </tr>
  }
}

const mapDispatchToProps = dispatch => ({
  onSave(data) {
    dispatch(addEntry(data))
  }
});

export default connect(null, mapDispatchToProps)(NewEntry);
