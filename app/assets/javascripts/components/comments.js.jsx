var Comments = React.createClass({
  
  render() {

    var createItem = ({content}) => <Comment comment={content} />; 

    return <div>{this.props.comments.map(createItem)}</div>;
  }
})