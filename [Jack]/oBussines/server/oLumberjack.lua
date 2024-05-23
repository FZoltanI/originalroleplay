trees = {
    positions = {
        {x = 2390.5048828125, y = -663.08404541016, z = 126.90968322754},
        {x = 2403.2556152344, y = -676.70281982422, z = 126.2191619873}
    },
    spawned = {}
}
Async:setDebug(true);
Async:setPriority("low"); 

function loadAllTree()
    Async:foreach(trees.positions, function(tree, i)
        spawnTree(i, tree.x, tree.y, tree.z)
    end);
end
addEventHandler ( "onResourceStart", getRootElement(), loadAllTree )

function spawnTree(id, x, y, z)
    if (id and x and y and z) then
        trees.spawned[id] = createObject(settings.objects.tree, x, y, z)
        setElementData(trees.spawned[id], 'tree:id', id)
        setElementData(trees.spawned[id], 'tree:state', true)
        setElementData(trees.spawned[id], 'tree:owner', 0)
        setElementData(trees.spawned[id], 'tree:health', settings.lumberjack.treeHealth)
    end
end