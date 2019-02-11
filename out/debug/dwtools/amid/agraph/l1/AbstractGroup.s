( function _AbstractGroup_s_( ) {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = function wAbstractGraphGroup( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'AbstractGraphGroup';

// --
// routine
// --

function init( o )
{
  let group = this;

  group[ nodesSymbol ] = [];
  // group[ directSymbol ] = true;

  _.instanceInit( group );
  Object.preventExtensions( group );

  if( o )
  group.copy( o );

  group.form();

  return group;
}

//

function finit()
{
  let group = this;
  group.unform();
  _.Copyable.prototype.finit.call( group );
}

//

function form()
{
  let group = this;
  _.assert( group.sys instanceof group.System );
  _.arrayAppendOnceStrictly( group.sys.groups, group );
}

//

function unform()
{
  let group = this;
  group.nodesDelete();
  _.arrayRemoveOnceStrictly( group.sys.groups, group );
}

//

function clone()
{
  let group = this;
  let group2 = _.Copyable.prototype.clone.apply( group, arguments );
  return group2;
}

// --
// reverse
// --

function directSet( val )
{
  let group = this;
  let nodes = group.nodes;

  _.assert( arguments.length === 1 );
  _.assert( _.boolLike( val ) );

  val = !!val;

  if( group[ directSymbol ] === undefined )
  {
    group[ directSymbol ] = val;
    return val;
  }

  group.reverse( val );

  return val;
}

//

function reverse( val )
{
  let group = this;
  let nodes = group.nodes;

  if( val === undefined )
  val = !group.direct;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( group.direct === val )
  return group;

  if( !val && !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let onOutNodesFor = group.onOutNodesFor;
  let onInNodesFor = group.onInNodesFor;

  _.assert( _.routineIs( onOutNodesFor ), 'Direct neighbour nodes getter is not defined' );
  _.assert( _.routineIs( onInNodesFor ), 'Reverse neighbour nodes getter is not defined' );

  group.onOutNodesFor = onInNodesFor;
  group.onInNodesFor = onOutNodesFor;

  group[ directSymbol ] = val;
  return group;
}

//

function cacheInNodesFromOutNodes()
{
  let group = this;
  let nodes = group.nodes;

  _.assert( arguments.length === 0 );

  if( group._inNodesCacheHash )
  return group;

  if( !group.onInNodesFor )
  group.onInNodesFor = group.fromCachedOnInNodesFor;
  if( !group.onInNodesIdsFor )
  group.onInNodesIdsFor = group.fromInNodesOnInNodesIdsFor;

  group._inNodesCacheHash = new Map();
  group.nodes.forEach( ( nodeHandle1 ) =>
  {
    group._inNodesCacheHash.set( nodeHandle1, new Array );
  });

  group.nodes.forEach( ( nodeHandle1 ) =>
  {
    let directNeighbours = group.nodeOutNodesFor( nodeHandle1 );
    directNeighbours.forEach( ( nodeHandle2 ) =>
    {
      let reverseNeighbours = group._inNodesCacheHash.get( nodeHandle2 );
      _.assert( !!reverseNeighbours, 'Node is not on the list of the graph group' );
      reverseNeighbours.push( nodeHandle1 );
    });
  });

  return group;
}

//

function cachesInvalidate()
{
  let group = this;
  debugger;
  _.assert( 'not tested' );
  if( group._inNodesCacheHash )
  group._inNodesCacheHash.clear();
  group._inNodesCacheHash = null;
  return group;
}

//

function exportData( o )
{
  let group = this;
  return group._exportData( o );
}

//

function _exportData( it )
{
  let group = this;
  let sys = group.sys;

  let result = Object.create( null );
  result./**/nodes = group.nodesExportData( group.nodes );

  return result;
}

//

function exportInfo( o )
{
  let group = this;
  let sys = group.sys;
  let result = group.nodesExportInfo( group.nodes );
  return result;
}

//

function nodeDescriptorGet( nodeId )
{
  let group = this;
  let sys = group.sys;
  return sys.nodeDescriptorGet.apply( sys, arguments );
}

//

function nodeDescriptorProduce( nodeId )
{
  let group = this;
  let sys = group.sys;
  return sys.nodeDescriptorProduce.apply( sys, arguments );
}

// --
// nodeHandle
// --

function nodeHas( nodeHandle )
{
  let group = this;
  _.assert( !!group.nodeIs( nodeHandle ) );
  return _.arrayHas( group.nodes, nodeHandle );
}

//

function nodeIs( nodeHandle )
{
  let group = this;
  return group.onNodeIs( nodeHandle );
}

// --
// nodeHandle
// --

function nodeIndegree( nodeHandle )
{
  let group = this;
  let nodes = group.nodeInNodesFor( nodeHandle );
  return nodes.length;
}

//

function nodeOutdegree( nodeHandle )
{
  let group = this;
  let nodes = group.nodeOutNodesFor( nodeHandle );
  return nodes.length;
}

//

function nodeDegree( nodeHandle )
{
  let group = this;
  let nodes1 = group.nodeInNodesFor( nodeHandle );
  let nodes2 = group.nodeOutNodesFor( nodeHandle );
  return nodes1.length + nodes2.length;
}

//

function nodeOutNodesFor( nodeHandle )
{
  let group = this;
  _.assert( !!group.nodeIs( nodeHandle ), 'Bad node' );
  _.assert( arguments.length === 1 );
  let result = group.onOutNodesFor( nodeHandle );
  _.assert( _.arrayIs( result ), 'Bad node' );
  return result;
}

//

function nodeInNodesFor( nodeHandle )
{
  let group = this;
  _.assert( !!group.nodeIs( nodeHandle ), 'Bad node' );
  _.assert( arguments.length === 1 );
  let result = group.onInNodesFor( nodeHandle );
  _.assert( _.arrayIs( result ), 'Bad node' );
  return result;
}

//

function nodeOutNodesIdsFor( nodeHandle )
{
  let group = this;
  _.assert( !!group.nodeIs( nodeHandle ) );
  _.assert( arguments.length === 1 );
  let result = group.onOutNodesIdsFor( nodeHandle );
  _.assert( _.arrayIs( result ) );
  return result;
}

//

function nodeInNodesIdsFor( nodeHandle )
{
  let group = this;
  _.assert( !!group.nodeIs( nodeHandle ) );
  _.assert( arguments.length === 1 );
  let result = group.onInNodesIdsFor( nodeHandle );
  _.assert( _.arrayIs( result ) );
  return result;
}

//

function nodeRefNumber( nodeId )
{
  let group = this;
  let sys = group.sys;

  _.assert( arguments.length === 1 );
  _.assert( !!nodeId, 'Expects node or node id' );
  _.assert( 'not tested' );

  if( !sys.idIs( nodeId ) )
  {
    let nodeId2 = group.nodeToIdTry( nodeId );
    if( nodeId2 === undefined )
    {
      _.assert( !!group.nodeIs( nodeId ), 'Expects node or node id' );
      return 0;
    }
    nodeId = nodeId2;
  }

  let descriptor = group.nodeDescriptorGet( nodeId );

  if( !descriptor )
  if( sys.idToNodeHash.has( nodeId ) )
  return 1;
  else
  return 0;

  _.assert( descriptor.count >= 0 );

  return descriptor.count;
}

//

function nodesSet( nodes )
{
  let group = this;
  let sys = group.sys;

  _.assert( arguments.length === 1 );
  _.assert( nodes === null || _.arrayIs( nodes ) );

  group.nodesDelete( group.nodes.slice() );
  if( nodes )
  group.nodesAdd( nodes );

  return group.nodes;
}

//

function nodeAdd( nodeHandle )
{
  let group = this;
  let sys = group.sys;

  _.assert( !!group.nodeIs( nodeHandle ), 'Expects nodeHandle' );
  _.assert( !_.arrayHas( group.nodes, nodeHandle ), 'The group does not have a node with such nodeHandle' );
  _.arrayAppendOnceStrictly( group.nodes, nodeHandle );

  let wasDefined = true;
  let id = sys.nodeToIdHash.get( nodeHandle );
  if( id === undefined )
  {
    id = ++sys.nodeCounter;
    wasDefined = false;
  }

  sys.nodeToIdHash.set( nodeHandle, id );
  sys.idToNodeHash.set( id, nodeHandle );

  if( wasDefined )
  {
    let descriptor = sys.nodeDescriptorsHash.get( id );
    if( !descriptor )
    {
      descriptor = Object.create( null );
      descriptor.count = 2;
      sys.nodeDescriptorsHash.set( id, descriptor );
    }
    else
    {
      descriptor.count += 1;
    }
  }

  return id;
}

//

function nodeDelete( nodeHandle )
{
  let group = this;
  let sys = group.sys;
  let id = sys.nodeToIdHash.get( nodeHandle );
  let descriptor = group.nodeDescriptorGet( nodeHandle );

  _.assert( !!group.nodeIs( nodeHandle ), 'Expects nodeHandle' );
  _.assert( sys.nodeToIdHash.has( nodeHandle ), 'The system does not have a node with such nodeHandle' );
  _.assert( descriptor === undefined || descriptor.count > 0, 'The system does not have information about number of the node' );
  _.assert( _.arrayHas( group.nodes, nodeHandle ), 'The group does not have a node with such nodeHandle' );

  _.arrayRemoveOnceStrictly( group.nodes, nodeHandle );

  if( descriptor && descriptor.count > 1 )
  {
    descriptor.count -= 1;
  }
  else
  {
    sys.nodeToIdHash.delete( nodeHandle );
    sys.idToNodeHash.delete( id );
    sys.nodeDescriptorsHash.delete( id );
  }

  return id;
}

//

let _nodesDelete = _.vectorize( nodeDelete );
function nodesDelete()
{
  let group = this;
  if( arguments.length === 0 )
  return group.nodesDelete( group.nodes.slice() );
  return _nodesDelete.apply( this, arguments );
}

//

function nodeExportData( nodeHandle )
{
  let group = this;

  _.assert( group.nodeIs( nodeHandle ) );

  let result = Object.create( null );
  result.id = group.nodeToId( nodeHandle );
  result.neighbours = group.nodesToIdsTry( group.nodeOutNodesFor( nodeHandle ) );

  return result;
}

//

function nodeExportInfo( nodeHandle )
{
  let group = this;

  let data = group.nodeExportData( nodeHandle );
  let result = String( data.id ) + ' : ';

  result += data.neighbours.join( ' ' );

  return result;
}

//

function nodesExportInfo( nodes )
{
  let group = this;
  _.assert( arguments.length === 0 || arguments.length === 1 )
  nodes = nodes || group.nodes;
  let result = nodes.map( ( nodeHandle ) => group.nodeExportInfo( nodeHandle ) );
  result = result.join( '\n' );
  return result;
}

//

function nodeToName( nodeHandle )
{
  let group = this;
  let sys = group.sys;
  _.assert( _.routineIs( group.onNodeNameGet ), 'Graph group does not have defined onNodeNameGet to been able to get name' );
  _.assert( group.nodeIs( nodeHandle ), 'Expects node' );
  _.assert( arguments.length === 1 );
  return group.onNodeNameGet( nodeHandle );
}

//

function nodeToIdTry( nodeHandle )
{
  let group = this;
  let sys = group.sys;
  return sys.nodeToIdTry( nodeHandle );
}

//

function nodeToId( nodeHandle )
{
  let group = this;
  let sys = group.sys;
  return sys.nodeToId( nodeHandle );
}

//

function idToNodesTry( nodeId )
{
  let group = this;
  let sys = group.sys;
  return sys.idToNodesTry( nodeId );
}

//

function idToNodes( nodeId )
{
  let group = this;
  let sys = group.sys;
  return sys.idToNodes( nodeId );
}

// --
// filter
// --

function leastIndegreeAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let result = Infinity;

  nodes.forEach( ( node ) =>
  {
    let d = group.nodeIndegree( node );
    if( d < result )
    result = d;
  });

  if( result === Infinity )
  result = 0;

  return result;
}

//

function mostIndegreeAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let result = 0;

  nodes.forEach( ( node ) =>
  {
    let d = group.nodeIndegree( node );
    if( d > result )
    result = d;
  });

  return result;
}

//

function leastOutdegreeAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let result = Infinity;

  nodes.forEach( ( node ) =>
  {
    let d = group.nodeOutdegree( node );
    if( d < result )
    result = d;
  });

  if( result === Infinity )
  result = 0;

  return result;
}

//

function mostOutdegreeAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let result = 0;

  nodes.forEach( ( node ) =>
  {
    let d = group.nodeOutdegree( node );
    if( d > result )
    result = d;
  });

  return result;
}

//

function leastIndegreeOnlyAmong( nodes )
{
  let group = this;
  if( nodes === undefined )
  nodes = group.nodes;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let degree = group.leastIndegreeAmong( nodes );
  let result = nodes.filter( ( node ) => group.nodeIndegree( node ) === degree );
  return result;
}

//

function mostIndegreeOnlyAmong( nodes )
{
  let group = this;
  if( nodes === undefined )
  nodes = group.nodes;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let degree = group.mostIndegreeAmong( nodes );
  let result = nodes.filter( ( node ) => group.nodeIndegree( node ) === degree );
  return result;
}


//

function leastOutdegreeOnlyAmong( nodes )
{
  let group = this;
  if( nodes === undefined )
  nodes = group.nodes;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let degree = group.leastOutdegreeAmong( nodes );
  let result = nodes.filter( ( node ) => group.nodeOutdegree( node ) === degree );
  return result;
}

//

function mostOutdegreeOnlyAmong( nodes )
{
  let group = this;
  if( nodes === undefined )
  nodes = group.nodes;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  let degree = group.mostOutdegreeAmong( nodes );
  let result = nodes.filter( ( node ) => group.nodeOutdegree( node ) === degree );
  return result;
}

//

function sourcesOnlyAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !group.onInNodesFor )
  group.cacheInNodesFromOutNodes();

  let result = nodes.filter( ( node ) => group.nodeInNodesFor( node ).length === 0 );

  return result;
}

//

function sinksOnlyAmong( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  // _.assert( group.nodesAreAll( nodes ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = nodes.filter( ( node ) => group.nodesOutNodesFor( node ).length === 0 );

  return result;
}

// --
// algos
// --

function lookBfs( o )
{
  let group = this;

  o.nodes = _.arrayAs( o.nodes );

  _.assert( arguments.length === 1 );
  _.assert( group.nodesAreAll( o.nodes ) );
  _.routineOptions( lookBfs, o );

  let it = Object.create( null );
  it.visited = [];
  it.layers = [];
  it.layer = 0;
  it.continue = true;
  it.continueNode = true;
  it.result = it.layers;
  it.options = o;

  visit( o.nodes, it );

  return it.result;

  /* */

  function visit( nodes, it )
  {
    let nodes2 = [];
    let nodes3 = [];

    if( o.onUp )
    o.onUp( nodes, it );

    if( it.continue )
    nodes.every( ( nodeHandle ) =>
    {
      if( _.arrayHas( it.visited, nodeHandle ) )
      return true;
      if( o.onNode )
      o.onNode( nodeHandle, it );
      if( it.continueNode )
      {
        nodes2.push( nodeHandle );
        it.visited.push( nodeHandle );
      }
      it.continueNode = true;
      return it.continue;
    });

    if( nodes2.length )
    {

      it.layers.push( nodes2 );

      if( it.continue )
      {

        nodes2.every( ( nodeHandle ) =>
        {
          let neigbours = group.nodeOutNodesFor( nodeHandle );
          _.arrayAppendArray( nodes3, neigbours );
          return true;
        });

        it.layer += 1;
        visit( nodes3, it );

      }

    }

    if( o.onDown )
    o.onDown( nodes2, it );
  }

}

lookBfs.defaults =
{
  nodes : null,
  onUp : null,
  onDown : null,
  onNode : null,
}

//

function lookDfs( o )
{
  let group = this;

  o.nodes = _.arrayAs( o.nodes );

  _.routineOptions( lookDfs, o );
  _.assert( arguments.length === 1 );
  _.assert( group.nodesAreAll( o.nodes ) );

  let it = Object.create( null );
  it.visited = [];
  it.continue = true;
  it.continueUp = true;
  it.result = false;
  it.options = o;

  o.nodes.forEach( ( node ) =>
  {
    it.node = node;
    it.id = group.nodeToId( node );
    visit( it )
  });

  return it.result;

  /* */

  function visit( it )
  {

    if( _.arrayHas( it.visited, it.node ) )
    return;
    it.visited.push( it.node );

    if( o.onUp )
    o.onUp( it.node, it );

    let node = it.node;
    let id = it.id;

    if( it.continue && it.continueUp )
    {
      let neigbours = group.nodeOutNodesFor( it.node );
      for( let n = 0 ; n < neigbours.length ; n++ )
      {
        it.node = neigbours[ n ];
        it.id = group.nodeToId( it.node );
        visit( it );
        if( !it.continue )
        break;
      }
    }

    it.node = node;
    it.id = id;

    if( o.onDown )
    o.onDown( it.node, it );

    it.continueUp = true;

  }

}

lookDfs.defaults =
{
  nodes : null,
  onUp : null,
  onDown : null,
}

//

function topologicalSortDfs( /**/nodes )
{
  let group = this;
  let ordering = [];
  let visited = [];

  if( /**/nodes === undefined )
  /**/nodes = group.nodes;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( group.nodesAreAll( /**/nodes ) );

  /**/nodes.forEach( ( nodeHandle ) =>
  {
    if( _.arrayHas( visited, nodeHandle ) )
    return;
    group.lookDfs({ nodes : nodeHandle, onDown : handleDown });
  });

  _.assert( ordering.length === /**/nodes.length );

  return ordering;

  /* */

  function handleDown( nodeHandle, it )
  {
    let neigbours = group.nodeOutNodesFor( nodeHandle );
    neigbours = neigbours.filter( ( nodeHandle2 ) => !_.arrayHas( visited, nodeHandle2 ) );
    if( neigbours.length === 0 )
    {
      ordering.push( nodeHandle );
    }
    visited.push( nodeHandle );
  }

}

//

function topologicalSortSourceBasedBfs( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let sources = group.leastIndegreeOnlyAmong( /**/nodes );
  let result = group.lookBfs({ nodes : sources });

  return result;
}

//

function topologicalSortCycledSourceBasedBfs( nodes )
{
  let group = this;

  if( nodes === undefined )
  nodes = group.nodes;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !nodes.length )
  return [];

  debugger;
  let sources = [];
  let tree = group.stronglyConnectedTreeFor( nodes );
  debugger;
  tree.nodes.forEach( ( node ) =>
  {
    if( tree.nodeIndegree( node ) === 0 )
    _.arrayAppendArray( sources, group.idsToNodes( node.originalNodes ) );
  });
  debugger;

  tree.finit();

  _.assert( sources.length > 0 );

  let result = group.lookBfs({ nodes : sources });

  return result;
}

// --
// connectivity algos
// --

function nodesAreConnectedDfs( handle1, handle2 )
{
  let group = this;

  _.assert( arguments.length === 2 );
  _.assert( !!group.nodeIs( handle1 ) );
  _.assert( !!group.nodeIs( handle2 ) );

  return group.lookDfs({ nodes : handle1, onUp : onUp });

  /* */

  function onUp( nodeHandle, it )
  {

    if( nodeHandle === handle2 )
    {
      it.continue = false;
      it.result = true;
    }

  }

}

//

function groupByConnectivityDfs( /**/nodes )
{
  let group = this;
  let groups = [];
  let visited = [];

  if( /**/nodes === undefined )
  /**/nodes = group.nodes;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( group.nodesAreAll( /**/nodes ) );

  /**/nodes.forEach( ( nodeHandle ) =>
  {
    let id = group.nodeToId( nodeHandle );
    if( _.arrayHas( visited, id ) )
    return;
    groups.push( [] );
    group.lookDfs({ nodes : nodeHandle, onUp : handleUp });
  });

  return groups;

  /* */

  function handleUp( nodeHandle, it )
  {
    let id = group.nodeToId( nodeHandle );
    visited.push( id );
    groups[ groups.length-1 ].push( id );
  }

}

//

function groupByStrongConnectivityDfs( /**/nodes )
{
  let group = this;
  let visited1 = [];
  let visited2 = [];
  let layers = [];

  if( /**/nodes === undefined )
  /**/nodes = group.nodes;
  /**/nodes = _.arrayAs( /**/nodes );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( group.nodesAreAll( /**/nodes ) );

  /* mark */

  group.reverse();

  /**/nodes.forEach( ( nodeHandle ) =>
  {
    if( visited1.indexOf( nodeHandle ) !== -1 )
    return;
    group.lookDfs({ nodes : nodeHandle, onUp : handleUp1, onDown : handleDown1 });
  });

  group.reverse();

  /* collect layers */

  for( let i = visited1.length-1 ; i >= 0 ; i-- )
  {
    let nodeHandle = visited1[ i ];
    if( visited2.indexOf( nodeHandle ) !== -1 )
    continue;
    layers.push( [] );
    group.lookDfs({ nodes : nodeHandle, onUp : handleUp2 });
  }

  /* */

  return layers;

  /* */

  function handleUp1( nodeHandle, it )
  {
    if( visited1.indexOf( nodeHandle ) !== -1 )
    {
      it.continueUp = false;
      return;
    }
  }

  /* */

  function handleDown1( nodeHandle, it )
  {
    if( !it.continueUp )
    return;
    visited1.push( nodeHandle );
  }

  /* */

  function handleUp2( nodeHandle, it )
  {
    if( visited2.indexOf( nodeHandle ) !== -1 )
    {
      it.continueUp = false;
      return;
    }
    _.assert( _.arrayHas( visited1, nodeHandle ), () => 'Input set of nodes does not have a node #' + group.nodeToId( nodeHandle ) );
    visited2.push( nodeHandle );
    layers[ layers.length - 1 ].push( nodeHandle );
  }

}

//

function stronglyConnectedTreeForDfs( /**/nodes )
{
  let group = this;
  let sys = group.sys;
  let visited1 = [];
  let visited2 = [];
  let layers = [];
  let outs = [];
  let fromOriginal = new Map();

  if( /**/nodes === undefined )
  /**/nodes = group.nodes;
  /**/nodes = _.arrayAs( /**/nodes );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( group.nodesAreAll( /**/nodes ) );

  /* mark */

  group.reverse();

  /**/nodes.forEach( ( nodeHandle ) =>
  {
    if( visited1.indexOf( nodeHandle ) !== -1 )
    return;
    group.lookDfs({ nodes : nodeHandle, onUp : handleUp1, onDown : handleDown1 });
  });

  group.reverse();

  /* collect layers */

  for( let i = visited1.length-1 ; i >= 0 ; i-- )
  {
    let nodeHandle = visited1[ i ];
    if( visited2.indexOf( nodeHandle ) !== -1 )
    continue;
    layers.push( [] );
    outs.push( [] );
    group.lookDfs({ nodes : nodeHandle, onUp : handleUp2 });
  }

  /* construct new graph */

  let group2 = sys.groupMake
  ({
    onOutNodesFor : group.fromOutNodesIdsOnOutNodesFor,
    onInNodesFor : group.fromInNodesIdsOnInNodesFor,
    onOutNodesIdsFor : group.fromOutNodesIdsOnOutNodesIdsFor,
    onInNodesIdsFor : group.fromInNodesIdsOnInNodesIdsFor,
  });

  for( let l = 0 ; l < layers.length ; l++ )
  {
    let node = Object.create( null );
    node.inNodes = [];
    node.outNodes = [];
    node.originalNodes = group.nodesToIds( layers[ l ] );
    group2.nodeAdd( node )
  }

  /* add edges */

  for( let l = 0 ; l < group2.nodes.length ; l++ )
  {
    let node = group2.nodes[ l ];
    let originalOutNodes = outs[ l ];
    for( let t = 0 ; t < originalOutNodes.length ; t++ )
    {
      let originalOutId = originalOutNodes[ t ];
      if( _.arrayHas( node.originalNodes, originalOutId ) )
      continue;
      let node2 = group2.nodes[ fromOriginal.get( originalOutId ) ];
      _.arrayAppendOnce( node.outNodes, sys.nodeToId( node2 ) );
      _.arrayAppendOnce( node2.inNodes, sys.nodeToId( node ) );
    }
  }

  /* */

  return group2;

  /* */

  function handleUp1( nodeHandle, it )
  {
    if( visited1.indexOf( nodeHandle ) !== -1 )
    {
      it.continueUp = false;
      return;
    }
  }

  /* */

  function handleDown1( nodeHandle, it )
  {
    if( !it.continueUp )
    return;
    visited1.push( nodeHandle );
  }

  /* */

  function handleUp2( nodeHandle, it )
  {
    if( visited2.indexOf( nodeHandle ) !== -1 )
    {
      it.continueUp = false;
      return;
    }
    _.assert( _.arrayHas( visited1, nodeHandle ), () => 'Input set of nodes does not have a node #' + group.nodeToId( nodeHandle ) );
    visited2.push( nodeHandle );
    let index = layers.length - 1;
    _.assert( sys.idIs( it.id ) );
    fromOriginal.set( it.id, index );
    layers[ index ].push( nodeHandle );
    _.arrayAppendArray( outs[ index ], group.nodeOutNodesIdsFor( nodeHandle ) );
  }

}

// --
// etc
// --

function defaultOnNodeName( nodeHandle )
{
  return nodeHandle.name;
}

//

function defaultOnNodeIs( nodeHandle )
{
  if( nodeHandle === null || nodeHandle === undefined )
  return false;
  return _.maybe;
}

//

function fromCachedOnInNodesFor( nodeHandle )
{
  let group = this;
  let neigbours = group._inNodesCacheHash.get( nodeHandle );
  _.assert( _.arrayIs( neigbours ), 'No cache for the node' );
  return neigbours;
}

//

function fromNodesOnOutNodesFor( nodeHandle )
{
  let group = this;
  return nodeHandle.nodes;
}

//

function fromOutNodesOnOutNodesFor( nodeHandle )
{
  let group = this;
  return nodeHandle.outNodes;
}

//

function fromInNodesOnInNodesFor( nodeHandle )
{
  let group = this;
  return nodeHandle.inNodes;
}

//

function fromNodesIdsOnOutNodesFor( nodeHandle )
{
  let group = this;
  return group.idsToNodes( nodeHandle.nodes );
}

//

function fromOutNodesIdsOnOutNodesFor( nodeHandle )
{
  let group = this;
  return group.idsToNodes( nodeHandle.outNodes );
}

//

function fromInNodesIdsOnInNodesFor( nodeHandle )
{
  let group = this;
  return group.idsToNodes( nodeHandle.inNodes );
}

//

function fromNodesOnOutNodesIdsFor( nodeHandle )
{
  let group = this;
  return group.nodesToIds( nodeHandle.nodes );
}

//

function fromOutNodesOnOutNodesIdsFor( nodeHandle )
{
  let group = this;
  return group.nodesToIds( nodeHandle.outNodes );
}

//

function fromInNodesOnInNodesIdsFor( nodeHandle )
{
  let group = this;
  return group.nodesToIds( nodeHandle.inNodes );
}

//

function fromNodesIdsOnOutNodesIdsFor( nodeHandle )
{
  let group = this;
  return nodeHandle.nodes;
}

//

function fromOutNodesIdsOnOutNodesIdsFor( nodeHandle )
{
  let group = this;
  return nodeHandle.outNodes;
}

//

function fromInNodesIdsOnInNodesIdsFor( nodeHandle )
{
  let group = this;
  return nodeHandle.inNodes;
}

// --
// relations
// --

let nodesSymbol = Symbol.for( 'nodes' );
let directSymbol = Symbol.for( 'direct' );

let Composes =
{
  direct : true,
}

let Aggregates =
{
  onNodeNameGet : defaultOnNodeName,
  onNodeIs : defaultOnNodeIs,
  onOutNodesFor : fromNodesOnOutNodesFor,
  onInNodesFor : null,
  onOutNodesIdsFor : fromNodesOnOutNodesIdsFor,
  onInNodesIdsFor : null,
}

let Associates =
{
  sys : null,
  nodes : null,
}

let Restricts =
{
  _inNodesCacheHash : null,
}

let Statics =
{
}

let Accessors =
{
  nodes : {},
  direct : {},
}

// --
// declare
// --

let Extend =
{

  init,
  finit,
  form,
  unform,
  clone,

  // reverse

  directSet,
  reverse,
  cacheInNodesFromOutNodes,
  cachesInvalidate,

  // export

  exportData,
  _exportData,
  exportInfo,

  // descriptor

  nodeDescriptorGet,
  nodeDescriptorProduce,

  // nodeHandle

  nodeHas,
  nodesHas : _.vectorize( nodeHas ),
  nodesHasAll : _.vectorizeAll( nodeHas ),
  nodesHasAny : _.vectorizeAny( nodeHas ),
  nodesHasNone : _.vectorizeNone( nodeHas ),

  nodeIs,
  nodesAre : _.vectorize( nodeIs ),
  nodesAreAll : _.vectorizeAll( nodeIs ),
  nodesAreAny : _.vectorizeAny( nodeIs ),
  nodesAreNone : _.vectorizeNone( nodeIs ),

  nodeIndegree,
  nodesIndegree : _.vectorize( nodeIndegree ),
  nodeOutdegree,
  nodesOutdegree : _.vectorize( nodeOutdegree ),
  nodeDegree,
  nodesDegree : _.vectorize( nodeDegree ),
  nodeOutNodesFor,
  nodesOutNodesFor : _.vectorize( nodeOutNodesFor ),
  nodeInNodesFor,
  nodesInNodesFor : _.vectorize( nodeInNodesFor ),
  nodeOutNodesIdsFor,
  nodesOutNodesIdsFor : _.vectorize( nodeOutNodesIdsFor ),
  nodeInNodesIdsFor,
  nodesInNodesIdsFor : _.vectorize( nodeInNodesIdsFor ),
  nodeRefNumber,
  nodesSet,

  nodeAdd,
  nodesAdd : _.vectorize( nodeAdd ),
  nodeDelete,
  nodesDelete,

  nodeExportData,
  nodesExportData : _.vectorize( nodeExportData ),
  nodeExportInfo,
  nodesExportInfo,

  nodeToName,
  nodesToNames : _.vectorize( nodeToName ),
  nodeToIdTry,
  nodesToIdsTry : _.vectorize( nodeToIdTry ),
  nodeToId,
  nodesToIds : _.vectorize( nodeToId ),
  idToNodesTry,
  idsToNodesTry : _.vectorize( idToNodesTry ),
  idToNodes,
  idsToNodes : _.vectorize( idToNodes ),

  // filter

  leastIndegreeAmong,
  mostIndegreeAmong,
  leastOutdegreeAmong,
  mostOutdegreeAmong,

  leastIndegreeOnlyAmong,
  mostIndegreeOnlyAmong,
  leastOutdegreeOnlyAmong,
  mostOutdegreeOnlyAmong,

  sourcesOnlyAmong,
  sinksOnlyAmong,

  // algos

  lookBfs,
  lookDfs,
  look : lookDfs,

  topologicalSortDfs,
  topologicalSort : topologicalSortDfs,
  topologicalSortSourceBasedBfs,
  topologicalSortSourceBased : topologicalSortSourceBasedBfs,
  topologicalSortCycledSourceBasedBfs,
  topologicalSortCycledSourceBased : topologicalSortCycledSourceBasedBfs,

  // connectivity algos

  nodesAreConnectedDfs,
  nodesAreConnected : nodesAreConnectedDfs,
  groupByConnectivityDfs,
  groupByConnectivity : groupByConnectivityDfs,
  groupByStrongConnectivityDfs,
  groupByStrongConnectivity : groupByStrongConnectivityDfs,
  stronglyConnectedTreeForDfs,
  stronglyConnectedTreeFor : stronglyConnectedTreeForDfs,

  // default

  defaultOnNodeName,
  defaultOnNodeIs,
  fromCachedOnInNodesFor,

  fromNodesOnOutNodesFor,
  fromOutNodesOnOutNodesFor,
  fromInNodesOnInNodesFor,
  fromNodesIdsOnOutNodesFor,
  fromOutNodesIdsOnOutNodesFor,
  fromInNodesIdsOnInNodesFor,

  fromNodesOnOutNodesIdsFor,
  fromOutNodesOnOutNodesIdsFor,
  fromInNodesOnInNodesIdsFor,
  fromNodesIdsOnOutNodesIdsFor,
  fromOutNodesIdsOnOutNodesIdsFor,
  fromInNodesIdsOnInNodesIdsFor,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extend,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_.graph[ Self.shortName ] = Self;

})();