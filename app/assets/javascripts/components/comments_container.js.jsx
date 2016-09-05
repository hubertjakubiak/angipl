var CommentsContainer = React.createClass({
  
  componentWillMount() {

    this.fetchComments();
    setInterval(this.fetchComments, 1000);
  },

  fetchComments() {

    $.getJSON(
      this.props.commentsPath,
      (data) => this.setState({comments: data.comments})
    );
  },

  getInitialState() {
    return { comments: [] };
  },
  
  render(){

    return <Comments comments={this.state.comments} />;
  }
})